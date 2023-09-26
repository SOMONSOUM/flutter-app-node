import express, { Application, Request, Response, NextFunction } from 'express'
import dotenv from 'dotenv'
import colors from 'colors'
import userRoute from './router/userRoute'
import todoRoute from './router/todoRoute'
import sequelize from './config/sequelize'
import User from './model/User'
import errorMiddleware from './middleware/errorMiddleware'
import Todo from './model/Todo'

dotenv.config()
const app: Application = express()
const PORT = process.env.PORT || 6000

app.use(express.json())
app.use(express.urlencoded({ extended: false }))

app.use('/dev/api/flutter/user', userRoute)
app.use('/dev/api/flutter/todo', todoRoute)
app.use('*', (req: Request, res: Response, next: NextFunction) => {
  res.status(404).send(`Page could not be found ${req.originalUrl}`)
})

app.use(errorMiddleware)

Todo.belongsTo(User, { constraints: true, onDelete: 'CASCADE' })
User.hasMany(Todo)

sequelize
  .sync({ alter: true })
  .then(() => {
    console.log(colors.green.underline.bold(`Database Connection Successfully`))
  })
  .catch((err) => {
    console.error(
      colors.red.underline(`Database Connection Error: ${err.message}`),
    )
  })

const server = app.listen(PORT, () => {
  console.log(
    colors.bgCyan.bold.inverse(
      `Server in ${process.env.NODE_ENV} is running on port ${process.env.PORT}`,
    ),
  )
})

process.on('unhandledRejection', (err, promise) => {
  server.close(() => process.exit(1))
  console.error(colors.red.bold.underline(`Error: ${err}`))
})
