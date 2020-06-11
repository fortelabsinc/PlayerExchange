import { filter, get } from 'lodash'

export const getAllPostings = ({ postings }) => postings
export const getMyPostings = ({ postings }, _, rootState) =>
  filter(
    postings,
    (posting) => posting.user_id === get(rootState, 'auth.user.name')
  )
