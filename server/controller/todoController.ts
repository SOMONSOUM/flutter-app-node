import asyncHandler from "express-async-handler"
import { RequestHandler } from "express"
import Todo, { TodoModel } from "../model/Todo"
import ErrorHandler from "../utility/errorHandler"

const getTodoRequest: RequestHandler= asyncHandler(async(req, res, next) =>{

  if(!req.user){
    throw new ErrorHandler(`User not authorized`, 401)
  }
  const todo = await Todo.findAll({ where: { userId: req.user.id }, order: [['createdAt', 'desc']] })
  if(todo.length === 0){
    throw new ErrorHandler(`Data not found`, 404)
  }

  res.status(200).json({ success:true, data: todo })

})

const postTodoRequest: RequestHandler= asyncHandler(async(req, res, next) =>{

  if(!req.user){
    throw new ErrorHandler(`User not authorized`, 401)
  }
  if(!req.user.id){
    throw new ErrorHandler(`User has been deleted`, 400)
  }

  const { title, content } = req.body
  const values={
    userId: req.user.id,
    title,
    content
  }
  
  const todo= await Todo.create(values)
  if(!todo){
    throw new ErrorHandler(`Todo not created`, 400)
  }

  res.status(201).json({ success:true, data: todo })

})

const putTodoRequest: RequestHandler= asyncHandler(async(req, res, next) =>{

  if(!req.user){
    throw new ErrorHandler(`User not authorized`, 401)
  }

  const {title, content} = req.body
  const todo= await Todo.findByPk(req.params.id) as TodoModel
  if(!todo){
    throw new ErrorHandler(`Data not found`, 404)
  }
  if(todo.userId !== req.user.id){
    throw new ErrorHandler(`User not authorized completely`, 401)
  }

  todo.title= title
  todo.content= content
  await todo.save()

  res.status(200).json({ success:true, data: todo })

})

const deleteTodoRequest: RequestHandler= asyncHandler(async(req, res, next) =>{

  if(!req.user){
    throw new ErrorHandler(`User not authorized`, 401)
  }

  const todo= await Todo.findByPk(req.params.id) as TodoModel
  if(!todo){
    throw new ErrorHandler(`Data not found`, 404)
  }
  if(todo.userId !== req.user.id){
    throw new ErrorHandler(`User not authorized completely`, 401)
  }
  await todo.destroy()

  res.status(200).json({ success:true, data: todo })

})

export {
  getTodoRequest,
  postTodoRequest,
  putTodoRequest,
  deleteTodoRequest
}