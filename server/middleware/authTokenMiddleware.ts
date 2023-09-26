import { RequestHandler } from "express";
import asyncHandler from "express-async-handler";
import ErrorHandler from "../utility/errorHandler";
import jsonwebtoken from "jsonwebtoken";
import User, { UserModel } from "../model/User";

declare global {
  namespace Express {
    interface Request {
      user: UserModel;
    }
  }
}
interface Decoded {
  id: number;
  iat: number;
  exp: number;
}

const authTokenMiddleware: RequestHandler = asyncHandler(
  async (req, res, next) => {
    let token;
    try {
      if (
        req.headers.authorization &&
        req.headers.authorization.startsWith("Bearer")
      ) {
        token = req.headers.authorization.split(" ")[1];
        const decoded = jsonwebtoken.verify(
          token,
          `${process.env.JWT_SECRET_KEY}`
        ) as Decoded;
        const user = (await User.findByPk(decoded.id)) as UserModel;
        req.user = user;
      }
    } catch (err) {
      throw new ErrorHandler(`Auth Token Unauthorized`, 401);
    }

    if (!token) {
      throw new ErrorHandler(`No Auth Token`, 404);
    }
    next();
  }
);

export default authTokenMiddleware;
