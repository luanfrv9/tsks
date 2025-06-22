import TextContent from "../layout/text/text-content";
import TextLabel from "../layout/text/text-label";
import TskStatus from "../layout/tsk-status";
import type { props as TSubtsk } from "../subtsk";
import Subtsks from "../subtsks";
import "./index.css";

export default ({
  value,
  subtsks,
  context = "inbox",
  status = "todo",
}: props) => (
  <li className={`tsks-item ${status}`}>
    <TskStatus status={status} />
    <div>
      <TextLabel>@{context}</TextLabel>
      <TextContent>{value}</TextContent>
      {subtsks && <Subtsks subtsks={subtsks} />}
    </div>
  </li>
);

export type props = {
  value: string;
  context?: string;
  status?: "todo" | "doing" | "done";
  subtsks?: TSubtsk[];
};
