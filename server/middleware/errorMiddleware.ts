import { ErrorRequestHandler } from "express";
import ErrorHandler from "../utility/errorHandler";

const errorMiddleware:ErrorRequestHandler = (err, req, res, next) =>{
  let error= {...err}
  error.statusCode= err.statusCode
  error.message= err.message
  error.stack= err.stack
  
  if(err.name === 'SequelizeValidationError'){
    const message= Object.values(error.errors).map((val:any) => val.message)
    error= new ErrorHandler(`${message}`, 400)
  }
  if(err.name === 'SequelizeUniqueConstraintError'){
    const message= Object.values(error.errors).map((val:any) => val.message)
    error= new ErrorHandler(`${message}`, 400)
  }

  const statusCode= error.statusCode || 500
  const message= error.message || "Server Internal Error"
  const stack= process.env.NODE_ENV === 'development' ? error.stack : null 
  res.status(statusCode).json({
    success:false,
    message,
    stack
  })
  
}

export default errorMiddleware