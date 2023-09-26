import { RequestHandler } from 'express'
import asyncHandler from 'express-async-handler'
import User, { UserModel } from '../model/User'
import ErrorHandler from '../utility/errorHandler'
import { Op } from 'sequelize'
import bcrypt from 'bcryptjs'
import jsonwebtoken from 'jsonwebtoken'

const authUserLogin: RequestHandler = asyncHandler(async (req, res, next) => {
  const { email, password } = req.body as UserModel
  console.log(req.body)

  if (!email) {
    throw new ErrorHandler(`Please input the email`, 400)
  }
  if (!password) {
    throw new ErrorHandler(`Please input the password`, 400)
  }

  const user = (await User.findOne({
    where: { email: { [Op.like]: `%${email.toLowerCase()}%` } },
  })) as UserModel
  if (!user) {
    throw new ErrorHandler(`Email not authorize`, 401)
  } else {
    if (password && (await bcrypt.compare(password, user.password!))) {
      user.isActive = true
      await user.save()

      const values = {
        id: user.id,
        name: user.name,
        email: user.email,
        phoneNumber: user.phoneNumber,
        role: user.role,
        isAdmin: user.isAdmin,
        isActive: user.isActive,
        createdAt: user.createdAt,
        token: generatedTokenUser(Number(user.id)),
      }
      res.status(200).json({ success: true, data: values })
    } else {
      throw new ErrorHandler(`Password not authorize`, 401)
    }
  }
})

const authUserRegister: RequestHandler = asyncHandler(
  async (req, res, next) => {
    const {
      name,
      email,
      password,
      confirmPassword,
      phoneNumber,
    } = req.body as UserModel
    if (password!.length < 6) {
      throw new ErrorHandler(`Password must be atleast 6 characters`, 400)
    }
    if (confirmPassword !== password) {
      throw new ErrorHandler(`Confirm password does not matched`, 400)
    }

    const nameExist = await User.findOne({
      where: { name: { [Op.like]: `%${name!.toLowerCase()}%` } },
    })
    if (nameExist) {
      throw new ErrorHandler(`Username is already taken`, 400)
    }

    const emailExist = await User.findOne({
      where: { email: { [Op.like]: `%${email!.toLowerCase()}%` } },
    })
    if (emailExist) {
      throw new ErrorHandler(`Email is already in used`, 400)
    }

    const genSalt = await bcrypt.genSalt(10)
    const hash = await bcrypt.hash(password!, genSalt)

    const values = {
      name,
      email,
      password: hash,
      phoneNumber,
      role: 'user',
      isAdmin: false,
      isActive: true,
    }
    const user = (await User.create(values)) as UserModel
    if (!user) {
      throw new ErrorHandler(`User not created`, 400)
    }

    res.status(201).json({
      success: true,
      data: {
        id: user.id,
        name: user.name,
        email: user.email,
        phoneNumber: user.phoneNumber,
        role: user.role,
        isAdmin: user.isAdmin,
        isActive: user.isActive,
        createdAt: user.createdAt,
        token: generatedTokenUser(Number(user.id)),
      },
    })
  },
)

const authGetUserProfile: RequestHandler = asyncHandler(
  async (req, res, next) => {
    if (!req.user) {
      throw new ErrorHandler(`User not authorized`, 401)
    }
    const user = (await User.findByPk(req.user.id)) as UserModel
    if (!user) {
      throw new ErrorHandler(`User not found`, 404)
    }

    res.status(200).json({
      success: true,
      data: {
        id: user.id,
        name: user.name,
        email: user.email,
        phoneNumber: user.phoneNumber,
        role: user.role,
        isAdmin: user.isAdmin,
        isActive: user.isActive,
        createdAt: user.createdAt,
        token: generatedTokenUser(Number(user.id)),
      },
    })
  },
)

const authUserLogout: RequestHandler = asyncHandler(async (req, res, next) => {
  if (!req.user) {
    throw new ErrorHandler(`User not authorized`, 401)
  }
  if (!req.user.id) {
    throw new ErrorHandler(`User has been deleted`, 400)
  }

  const user = (await User.findByPk(req.user.id)) as UserModel
  if (!user) {
    throw new ErrorHandler(`User not found`, 404)
  }
  user.isActive = false
  await user.save()

  res.status(200).json({ success: true, data: user })
})

const generatedTokenUser = (id: number) => {
  return jsonwebtoken.sign({ id }, `${process.env.JWT_SECRET_KEY}`, {
    expiresIn: `${process.env.JWT_EXPIRE_IN}`,
  })
}

export { authUserLogin, authUserRegister, authGetUserProfile, authUserLogout }
