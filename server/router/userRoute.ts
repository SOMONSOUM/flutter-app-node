import express from 'express'
import {
  authGetUserProfile,
  authUserLogin,
  authUserLogout,
  authUserRegister,
} from '../controller/userController'
import authTokenMiddleware from '../middleware/authTokenMiddleware'

const router = express.Router()
router.post('/login', authUserLogin)
router.post('/register', authUserRegister)
router.get('/profile', authTokenMiddleware, authGetUserProfile)
router.get('/logout', authTokenMiddleware, authUserLogout)

export default router
