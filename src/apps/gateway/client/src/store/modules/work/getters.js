import { filter, get } from 'lodash'

export const getAllPostings = ({ list }) => list
export const getMyPostings = ({ list }, _, rootState) =>
  filter(
    list,
    (posting) => posting.user_id === get(rootState, 'auth.user.name')
  )
export const getPostingsItemsPerPage = ({ itemsPerPage }) => itemsPerPage
