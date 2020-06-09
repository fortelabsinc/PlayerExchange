export const getLocalStorageToken = () => localStorage.getItem('token')
export const deleteLocalStorageToken = () => localStorage.removeItem('token')
export const setLocalStorageToken = (token) =>
  localStorage.setItem('token', token)
