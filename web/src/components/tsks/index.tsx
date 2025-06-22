import type { props as TSubtsk } from "../subtsk";
import type { props as TTsk } from "../tsk";
import Tsk from "../tsk";

export default () => (
  <ul className="tsks-list">
    {FAKE_TSKS.map(({ value, context, status, subtsks }: TTsk) => (
      <Tsk
        key={value}
        value={value}
        context={context}
        status={status}
        subtsks={subtsks}
      />
    ))}
  </ul>
);

const FAKE_SUBTSKS: TSubtsk[] = [
  {
    value: "todo",
  },
  {
    value: "doing",
    status: "doing",
  },
  {
    value: "done",
    status: "done",
  },
];

const FAKE_TSKS: TTsk[] = [
  {
    value: "something todo right now following 2min todo rule",
  },
  {
    value: "research gorillaz albums",
    context: "to-listen",
    status: "doing",
    subtsks: FAKE_SUBTSKS,
  },
  {
    value: "get ready for dungeons with my human hunter char",
    context: "wow",
    status: "doing",
  },
  {
    value: "publish tsks-webapp on github",
    context: "tsks",
    status: "done",
  },
];
