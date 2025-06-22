import Subtsk from '../subtsk'
import type { props as TSubtsk } from '../subtsk'
import SubtsksWrapper from '../subtsks-wrapper'
import './index.css'

export default ({ subtsks }: props) => {
  return (
    <SubtsksWrapper count={subtsks.length}>
      <ul className='tsks-list'>
        {subtsks.map(({ value, status }: TSubtsk) => (
          <Subtsk key={value} value={value} status={status} />
        ))}
      </ul>
    </SubtsksWrapper>
  )
}

type props = {
  subtsks: TSubtsk[]
}
