import type { ReactNode } from 'react'
import './index.css'

export default ({ children }: { children: ReactNode }) => (
  <p className='tsk-text'>{children}</p>
)
