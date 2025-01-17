import express from 'express'
import { createServer } from 'http'
import { Server } from 'socket.io'
import cors from 'cors'
import { authMiddleware, integrationAuthMiddleware } from './middlewares/authMidleware'
import authRoutes from './routes/authRoutes'
import { configDotenv } from 'dotenv'
import userRoutes from './routes/userRoutes'
import logger from './core/resources/pinoLogger'
import { performSoftDeletes } from './core/utils/softDelete'
import cron from 'node-cron'
import categoryRouter from './routes/categoryRoutes'
import authRouter from './routes/authRoutes'
import productRouter from './routes/productRoutes'
import systemMessagesRouter from './routes/systemMessagesRoutes'
import reviewRouter from './routes/reviewRoutes'
import cartRouter from './routes/cartRoutes'
import wishlistRouter from './routes/wishlistRoutes'
import userRouter from './routes/userRoutes'
import showcaseRouter from './routes/ShowcaseRoutes'
import authorRouter from './routes/authorRoutes'

configDotenv({ path: __dirname + '../../../.env' })

const app = express()
const port = process.env.HTTP_PORT || 4003

console.log(process.env.HTTP_PORT)
console.log(process.env.DB_USER)
console.log(process.env.DB_PASSWORD)

// CORS OPTIONS WILL BE DETERMINED BY SERVER APACHE/NGINX CONFIG
// remember to strict the cors in production
const corOptions = {
  origin: '*',
}

// this part is for initiating the socket.io
const httpServer = createServer(app)
// const io = new Server(httpServer, {
//   // cors: corOptions
// })
app.use(cors(corOptions))

app.use(express.json({ limit: '50mb' }))
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

// Schedule the soft delete task to run every night at midnight
/*cron.schedule('0 0 * * *', async () => {
  console.log('Running nightly soft delete task...');

  // Call soft deletes for each model you want to clean up
  await performSoftDeletes('category'); // Pass model name as string
  await performSoftDeletes('product');  // Another example
  // Add more models as needed
});*/

// Logging middleware for requests
app.use((req, res, next) => {
  logger.info({ req: { method: req.method, url: req.url } }, 'Request received')
  next()
})

app.use('/api/auth', authRouter)
app.use('/api/system_messages', systemMessagesRouter)
app.use('/api/showcase', showcaseRouter)
app.use('/api/categories', categoryRouter)
app.use('/api/products', productRouter)
app.use('/api/authors', authorRouter)
app.use('/api/reviews', reviewRouter)

// routes need auth
app.use('/api/cart', authMiddleware, cartRouter)
app.use('/api/wishlist', authMiddleware, wishlistRouter)
app.use('/api/users', authMiddleware, userRouter)

app.get('/', async (req, res, next) => {
  res.send({ message: '🚀 "A" API ready to serve! 🚀' })
})

httpServer.listen(port, () => logger.info(`🚀 API listening at http://localhost:${port} 🚀`))
