import { DataTypes } from "sequelize";
import sequelize from "../config/sequelize";

export interface TodoModel{
  id?: number,
  userId?:number,
  title?: string,
  content?: string,
  createdAt?: Date,
  save(): unknown,
  destroy(): unknown,
}

const Todo= sequelize.define('todos', {
  id:{
    type: DataTypes.INTEGER,
    autoIncrement:true,
    primaryKey:true,
    allowNull:false,
  },
  title:{
    type: DataTypes.STRING,
    allowNull:false,
    validate:{
      notNull:{
        msg: "Please input the title"
      }
    }
  },
  content:{
    type: DataTypes.TEXT,
    allowNull:false,
    validate:{
      notNull:{
        msg: "Please input the content"
      }
    }
  }
}, {
  timestamps:true,
  freezeTableName:true,
})

export default Todo