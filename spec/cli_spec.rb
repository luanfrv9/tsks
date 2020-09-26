RSpec.describe Tsks::CLI do
  context "Commands" do
    before :all do
      @setup_folder = described_class.setup_folder
    end

    describe "init" do
      after :each do
        if File.directory? @setup_folder
          FileUtils.rmtree @setup_folder
        end
      end

      it "Creates the setup folder" do
        allow(Tsks::Storage).to receive :init
        expect(Dir).to receive :mkdir
        described_class.start ["init"]
      end

      it "Initializes the database" do
        expect(Tsks::Storage).to receive :init
        described_class.start ["init"]
      end

      it "Shows an already initialized message" do
        described_class.start ["init"]
        expect {
          described_class.start ["init"]
        }.to output("tsks was already initialized.\n").to_stdout
      end
    end

    describe "add" do
      after :each do
        if File.directory? @setup_folder
          FileUtils.rmtree @setup_folder
        end
      end

      before :each do
        described_class.start ["init"]
      end

      let(:tsk) { "Finish my pet project" }
      let(:ctx) { "Work" }

      it "Enters a new tsk" do
        expect(Tsks::Storage).to receive(:insert).with(tsk)
        described_class.start ["add", tsk]
      end

      it "Enters a new tsk with a context" do
        expect(Tsks::Storage).to receive(:insert).with(tsk, ctx)
        described_class.start ["add", tsk, "--context=#{ctx}"]
      end
    end

    describe "done" do
      after :each do
        if File.directory? @setup_folder
          FileUtils.rmtree @setup_folder
        end
      end

      before :each do
        described_class.start ["init"]
        storage = SQLite3::Database.new File.join @setup_folder, "tsks.db"
        storage.execute(
          "INSERT INTO tsks (tsk, created_at, updated_at)
          VALUES ('tsk', '0', '0')"
        )
      end

      it "Marks a tsk as done" do
        expect(Tsks::Storage).to receive(:update).with(1)
        described_class.start ["done", 1]
      end
    end

    describe "list" do
      before :each do
        described_class.start ["init"]
        storage = SQLite3::Database.new File.join @setup_folder, "tsks.db"
        storage.execute(
          "INSERT INTO tsks (tsk, created_at, updated_at)
          VALUES ('tsk', '0', '0')"
        )
        storage.execute(
          "INSERT INTO tsks (tsk, done, created_at, updated_at)
          VALUES ('tsk', 1, '0', '0')"
        )
        storage.execute(
          "INSERT INTO tsks (tsk, context, created_at, updated_at)
          VALUES ('tsk', 'Work', '0', '0')"
        )
      end

      after :each do
        if File.directory? @setup_folder
          FileUtils.rmtree @setup_folder
        end
      end

      it "Lists all active tsks" do
        expect {
          described_class.start ["list"]
        }.to output("1 @Inbox tsk\n3 @Work tsk\n").to_stdout
      end

      it "Lists all done tsks" do
        expect {
          described_class.start ["list", "--done"]
        }.to output("2 @Inbox tsk\n").to_stdout
      end

      it "Lists all tsks from a context" do
        expect {
          described_class.start ["list", "--context=Work"]
        }.to output("3 @Work tsk\n").to_stdout
      end

      it "Shows a no tsks found message" do
        expect {
          described_class.start ["list", "--done", "--context=Work"]
        }.to output("No tsks found.\n").to_stdout
      end
    end

    describe "register" do
      before :each do
        described_class.start ["init"]
      end

      after :each do
        if File.directory? @setup_folder
          FileUtils.rmtree @setup_folder
        end
      end

      let(:req_body) { {email: "tsks@api.com", password: "secret"} }
      let(:res_body) { {status_code: 201, token: "token"} }
      let(:bad_res_body) { {status_code: 409} }

      it "Posts credentials to the register api endpoint" do
        expect(Tsks::Request).to receive(:post)
          .with("/register", req_body).and_return(res_body)
        described_class.start ["register",
                               "--email=#{req_body[:email]}",
                               "--password=#{req_body[:password]}"]
      end

      it "Storages the authentication token" do
        token_path = File.join @setup_folder, "token"
        allow(Tsks::Request).to receive(:post).and_return(res_body)
        expect(File).to receive(:write).with(token_path, res_body[:token])
        described_class.start ["register", "--email=@", "--password=s"]
      end

      it "Shows a successful registered message" do
        allow(Tsks::Request).to receive(:post).and_return(res_body)
        expect {
          described_class.start ["register", "--email=@", "--password=s"]
        }.to output("Succesfully registered.\n").to_stdout
      end

      it "Shows an already registered message" do
        allow(Tsks::Request).to receive(:post).and_return(bad_res_body)
        expect {
          described_class.start ["register", "--email=@", "--password=s"]
        }.to output("This e-mail is already registered.\n").to_stdout
      end
    end

    describe "login" do
      before :each do
        described_class.start ["init"]
      end

      after :each do
        if File.directory? @setup_folder
          FileUtils.rmtree @setup_folder
        end
      end

      let(:req_body) { {email: "tsks@api.com", password: "secret"} }
      let(:res_body) { {status_code: 200, token: "token"} }
      let(:bad_res_body) { {status_code: 403} }

      it "Posts credentials to the login api endpoint" do
        expect(Tsks::Request).to receive(:post)
          .with("/login", req_body).and_return(res_body)
        described_class.start ["login",
                               "--email=#{req_body[:email]}",
                               "--password=#{req_body[:password]}"]
      end

      it "Storages the authentication token" do
        token_path = File.join @setup_folder, "token"
        allow(Tsks::Request).to receive(:post).and_return(res_body)
        expect(File).to receive(:write).with(token_path, res_body[:token])
        described_class.start ["login", "--email=@", "--password=s"]
      end

      it "Shows a successful logged in message" do
        allow(Tsks::Request).to receive(:post).and_return(res_body)
        expect {
          described_class.start ["login", "--email=@", "--password=s"]
        }.to output("Succesfully logged in.\n").to_stdout
      end

      it "Shows an invalid credentials message" do
        allow(Tsks::Request).to receive(:post).and_return(bad_res_body)
        expect {
          described_class.start ["login", "--email=@", "--password=s"]
        }.to output("Invalid e-mail or password.\n").to_stdout
      end
    end

    describe "sync" do
      before :each do
        described_class.start ["init"]
      end

      after :each do
        if File.directory? @setup_folder
          FileUtils.rmtree @setup_folder
        end
      end

      let(:local_tsks) {
        [{id: 1,
         tsk: "t",
         context: "Inbox",
         done: 0,
         created_at: "2020-09-26 20:14:13",
         updated_at: "2020-09-26 20:14:13"},
        {id: 2,
         tsk: "t",
         context: "Inbox",
         done: 0,
         created_at: "0",
         updated_at: "0"}]
      }
      let(:remote_tsks) {
        [{id: 1,
         tsk: "t",
         context: "Inbox",
         done: 0,
         created_at: "2020-09-26 20:14:13",
         updated_at: "2020-09-26 20:14:13"},
        {id: 3,
         tsk: "t",
         context: "Inbox",
         done: 0,
         created_at: "2020-09-26 20:14:13",
         updated_at: "2020-09-26 20:14:13"}]
      }

      let(:not_synced_local_tsks) { [local_tsks.last] }
      let(:get_res) { {status_code: 200, tsks: remote_tsks} }
      let(:post_body) { {tsks: not_synced_local_tsks} }
      let(:not_synced_remote_tsks) { [remote_tsks.last] }

      it "Requires a login before sync" do
        expect {
          described_class.start ["sync"]
        }.to output("Please, login before try to sync.\n").to_stdout
      end

      it "Gets tsks from the API" do
        File.write File.join(@setup_folder, "token"), "token"
        allow(Tsks::Request).to receive(:post)
        expect(Tsks::Request).to receive(:get).with("/tsks", "token")
          .and_return(get_res)
        described_class.start ["sync"]
      end

      it "Posts not synced tsks to the API" do
        File.write File.join(@setup_folder, "token"), "token"
        allow(Tsks::Request).to receive(:get).and_return(get_res)
        allow(Tsks::Storage).to receive(:select_all).and_return(local_tsks)
        expect(Tsks::Request).to receive(:post)
          .with("/tsks", "token", post_body)
        described_class.start ["sync"]
      end

      it "Storages not present locally tsks" do
        File.write File.join(@setup_folder, "token"), "token"
        allow(Tsks::Request).to receive(:get).and_return(get_res)
        allow(Tsks::Storage).to receive(:select_all).and_return(local_tsks)
        allow(Tsks::Request).to receive(:post)
        expect(Tsks::Storage).to receive(:insert_many)
          .with(not_synced_remote_tsks)
        described_class.start ["sync"]
      end

      it "Shows a synchronization success message" do
        File.write File.join(@setup_folder, "token"), "token"
        allow(Tsks::Request).to receive(:get).and_return(get_res)
        allow(Tsks::Storage).to receive(:select_all).and_return(local_tsks)
        allow(Tsks::Request).to receive(:post)
        allow(Tsks::Storage).to receive(:insert_many)
        expect {
          described_class.start ["sync"]
        }.to output("Your tsks were succesfully synchronized.\n").to_stdout
      end
    end
  end

  context "Not initialized" do
    it "Requires initialization before add a tsk" do
      expect {
        described_class.start ["add", "tsk"]
      }.to output("tsks was not initialized yet.\n").to_stdout
    end

    it "Requires initialization before done a tsk" do
      expect {
        described_class.start ["done", 1]
      }.to output("tsks was not initialized yet.\n").to_stdout
    end

    it "Requires initialization before list tsks" do
      expect {
        described_class.start ["list"]
      }.to output("tsks was not initialized yet.\n").to_stdout
    end

    it "Requires initialization before register" do
      expect {
        described_class.start ["register", "--email=@", "--password=s"]
      }.to output("tsks was not initialized yet.\n").to_stdout
    end

    it "Requires initialization before login" do
      expect {
        described_class.start ["login", "--email=@", "--password=s"]
      }.to output("tsks was not initialized yet.\n").to_stdout
    end

    it "Requires initialization before sync" do
      expect {
        described_class.start ["sync"]
      }.to output("tsks was not initialized yet.\n").to_stdout
    end
  end
end
