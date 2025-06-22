import IconAsterisc from "../icon/icon-asterisc";
import IconMinus from "../icon/icon-minus";
import IconPlus from "../icon/icon-plus";
import "./index.css";

export default ({ status }: props) => (
  <span className="tsk-status">{STATUS_OPTS[status]}</span>
);

const STATUS_OPTS = {
  todo: <IconMinus />,
  doing: <IconPlus />,
  done: <IconAsterisc />,
};

type props = {
  status: "todo" | "doing" | "done";
};
