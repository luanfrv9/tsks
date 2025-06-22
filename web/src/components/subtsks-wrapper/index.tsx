import { type ReactNode, useState } from 'react'
import TextLabel from '../layout/text/text-label'
import './index.css'

export default ({ children, count }: props) => {
  const [isActive, setIsActive] = useState<boolean>(true)
  const toggleActive = () => setIsActive(!isActive)

  return (
    <div className='subtsks-wrapper'>
      <p
        className='tsk-subtsks-title'
        onClick={toggleActive}
        onKeyUp={toggleActive}
      >
        <TextLabel> subtsks ({count})</TextLabel>
      </p>
      {isActive && children}
    </div>
  )
}

type props = {
  children: ReactNode
  count: number
}
