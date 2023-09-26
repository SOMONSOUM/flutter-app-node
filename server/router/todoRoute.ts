import express from "express"
import { deleteTodoRequest, getTodoRequest, postTodoRequest, putTodoRequest } from "../controller/todoController"
import authTokenMiddleware from "../middleware/authTokenMiddleware"

const router= express.Router()
router.use(authTokenMiddleware)
router.route('/').get(getTodoRequest).post(postTodoRequest)
router.route('/:id').put(putTodoRequest).delete(deleteTodoRequest)

export default router