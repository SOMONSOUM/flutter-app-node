import { DataTypes, ModelDefined, Optional } from "sequelize";
import sequelize from "../config/sequelize";
import bcrypt from "bcryptjs"

export interface UserModel{
  id?:number,
  name?: string,
  email?: string,
  phoneNumber?:number,
  password?: string,
  confirmPassword?:string,
  role?: string,
  isAdmin?: boolean,
  isActive?: boolean,
  createdAt?: Date,
  save(): unknown,
}

const User= sequelize.define('users', {
  id:{
    type: DataTypes.INTEGER,
    autoIncrement:true,
    primaryKey:true,
    allowNull:false
  },
  name:{
    type: DataTypes.STRING,
    allowNull:false,
    unique:true,
    validate:{
      notNull:{
        msg: "Please input the name"
      }
    }
  },
  email:{
    type: DataTypes.STRING,
    allowNull:false,
    unique:true,
    validate:{
      isEmail:{
        msg: "Email invalid"
      },
      notNull:{
        msg: "Please input the email"
      }
    }
  },
  phoneNumber:{
    type: DataTypes.INTEGER,
    allowNull:false,
    validate:{
      notNull:{
        msg: "Please input the phone number"
      },
      isInt:{
        msg: "Number only",
      }
    },
  },
  password:{
    type: DataTypes.STRING,
    allowNull:false,
    validate:{
      notNull:{
        msg: "Please input the password"
      }
    },
  },
  role:{
    type: DataTypes.STRING,
    allowNull:false,
    defaultValue:'user',
    validate:{
      notNull:{
        msg: "Please input the role"
      },
      isIn:{
        args: [['user','admin']],
        msg: "Need to be user or admin only"
      }
    },
  },
  isAdmin:{
    type: DataTypes.BOOLEAN,
    allowNull:false,
    defaultValue: false,
    validate:{
      notNull:{
        msg: "Please input the admin type"
      },
      isIn:{
        args: [[true,false]],
        msg: "Need to be true or false only"
      }
    },
  },
  isActive:{
    type: DataTypes.BOOLEAN,
    allowNull:false,
    defaultValue: true,
    validate:{
      notNull:{
        msg: "Please input the type"
      },
      isIn:{
        args: [[true,false]],
        msg: "Need to be true or false only"
      }
    },
  },
}, {
  timestamps:true,
  freezeTableName:true,
});

export default User;