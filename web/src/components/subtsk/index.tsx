import TskStatus from '../layout/tsk-status'
import './index.css'

export default ({ value, status = 'todo' }: props) => (
  <li className={`tsk-subtsk ${status}`}>
    <TskStatus status={status} />
    <p className='tsk-text'>{value}</p>
  </li>
)

export type props = {
  value: string
  status?: 'todo' | 'doing' | 'done'
}
