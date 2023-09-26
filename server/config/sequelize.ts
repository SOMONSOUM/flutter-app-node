import { Sequelize } from 'sequelize'
import dotenv from 'dotenv'

dotenv.config()
const sequelize = new Sequelize(
  'mysql://root:soksan@localhost:3306/flutternode',
  {
    host: `${process.env.HOST}`,
    dialect: 'mysql',
  },
)
export default sequelize
