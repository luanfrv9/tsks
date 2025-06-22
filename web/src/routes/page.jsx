import { Helmet } from "@modern-js/runtime/head";
import TextHeading from "../components/layout/text/text-heading";
import TextSubHeading from "../components/layout/text/text-subheading";
import TskInput from "../components/tsk-input";
import TsksSection from "../components/tsks-section";
import "./index.css";

const Index = () => (
  <div className="container-box">
    <Helmet>
      <link
        rel="icon"
        type="image/x-icon"
        href="https://lf3-static.bytednsdoc.com/obj/eden-cn/uhbfnupenuhf/favicon.ico"
      />
    </Helmet>
    <main>
      <TextHeading />
      <TextSubHeading />
      <TskInput />
      <TsksSection />
    </main>
  </div>
);

export default Index;
