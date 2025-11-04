# Test-Integration - Llms-Txt

**Pages:** 93

---

## Accepts Helper

**URL:** llms-txt#accepts-helper

**Contents:**
- Import
- `accepts()`
  - `AcceptHeader` type
- Options
  - <Badge type="danger" text="required" /> header: `AcceptHeader`
  - <Badge type="danger" text="required" /> supports: `string[]`
  - <Badge type="danger" text="required" /> default: `string`
  - <Badge type="info" text="optional" /> match: `(accepts: Accept[], config: acceptsConfig) => string`

Accepts Helper helps to handle Accept headers in the Requests.

The `accepts()` function looks at the Accept header, such as Accept-Encoding and Accept-Language, and returns the proper value.

### `AcceptHeader` type

The definition of the `AcceptHeader` type is as follows.

### <Badge type="danger" text="required" /> header: `AcceptHeader`

The target accept header.

### <Badge type="danger" text="required" /> supports: `string[]`

The header values which your application supports.

### <Badge type="danger" text="required" /> default: `string`

### <Badge type="info" text="optional" /> match: `(accepts: Accept[], config: acceptsConfig) => string`

The custom match function.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { accepts } from 'hono/accepts'
```

Example 2 (ts):
```ts
import { accepts } from 'hono/accepts'

app.get('/', (c) => {
  const accept = accepts(c, {
    header: 'Accept-Language',
    supports: ['en', 'ja', 'zh'],
    default: 'en',
  })
  return c.json({ lang: accept })
})
```

Example 3 (ts):
```ts
export type AcceptHeader =
  | 'Accept'
  | 'Accept-Charset'
  | 'Accept-Encoding'
  | 'Accept-Language'
  | 'Accept-Patch'
  | 'Accept-Post'
  | 'Accept-Ranges'
```

---

## Adapter Helper

**URL:** llms-txt#adapter-helper

**Contents:**
- Import
- `env()`
  - Specify the runtime
- `getRuntimeKey()`
  - Available Runtimes Keys

The Adapter Helper provides a seamless way to interact with various platforms through a unified interface.

The `env()` function facilitates retrieving environment variables across different runtimes, extending beyond just Cloudflare Workers' Bindings. The value that can be retrieved with `env(c)` may be different for each runtimes.

Supported Runtimes, Serverless Platforms and Cloud Services:

- Cloudflare Workers
  - `wrangler.toml`
  - `wrangler.jsonc`
- Deno
  - [`Deno.env`](https://docs.deno.com/runtime/manual/basics/env_variables)
  - `.env` file
- Bun
  - [`Bun.env`](https://bun.com/guides/runtime/set-env)
  - `process.env`
- Node.js
  - `process.env`
- Vercel
  - [Environment Variables on Vercel](https://vercel.com/docs/projects/environment-variables)
- AWS Lambda
  - [Environment Variables on AWS Lambda](https://docs.aws.amazon.com/lambda/latest/dg/samples-blank.html#samples-blank-architecture)
- Lambda@Edge\
  Environment Variables on Lambda are [not supported](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/add-origin-custom-headers.html) by Lambda@Edge, you need to use [Lamdba@Edge event](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-event-structure.html) as an alternative.
- Fastly Compute\
  On Fastly Compute, you can use the ConfigStore to manage user-defined data.
- Netlify\
  On Netlify, you can use the [Netlify Contexts](https://docs.netlify.com/site-deploys/overview/#deploy-contexts) to manage user-defined data.

### Specify the runtime

You can specify the runtime to get environment variables by passing the runtime key as the second argument.

The `getRuntimeKey()` function returns the identifier of the current runtime.

### Available Runtimes Keys

Here are the available runtimes keys, unavailable runtime key runtimes may be supported and labeled as `other`, with some being inspired by [WinterCG's Runtime Keys](https://runtime-keys.proposal.wintercg.org/):

- `workerd` - Cloudflare Workers
- `deno`
- `bun`
- `node`
- `edge-light` - Vercel Edge Functions
- `fastly` - Fastly Compute
- `other` - Other unknown runtimes keys

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { env, getRuntimeKey } from 'hono/adapter'
```

Example 2 (ts):
```ts
import { env } from 'hono/adapter'

app.get('/env', (c) => {
  // NAME is process.env.NAME on Node.js or Bun
  // NAME is the value written in `wrangler.toml` on Cloudflare
  const { NAME } = env<{ NAME: string }>(c)
  return c.text(NAME)
})
```

Example 3 (ts):
```ts
app.get('/env', (c) => {
  const { NAME } = env<{ NAME: string }>(c, 'workerd')
  return c.text(NAME)
})
```

Example 4 (ts):
```ts
app.get('/', (c) => {
  if (getRuntimeKey() === 'workerd') {
    return c.text('You are on Cloudflare')
  } else if (getRuntimeKey() === 'bun') {
    return c.text('You are on Bun')
  }
  ...
})
```

---

## Alibaba Cloud Function Compute

**URL:** llms-txt#alibaba-cloud-function-compute

**Contents:**
- 1. Setup
- 2. Hello World
- 3. Setup serverless-devs

[Alibaba Cloud Function Compute](https://www.alibabacloud.com/en/product/function-compute) is a fully managed, event-driven compute service. Function Compute allows you to focus on writing and uploading code without having to manage infrastructure such as servers.

This guide uses a third-party adapter [rwv/hono-alibaba-cloud-fc3-adapter](https://github.com/rwv/hono-alibaba-cloud-fc3-adapter) to run Hono on Alibaba Cloud Function Compute.

## 3. Setup serverless-devs

> [serverless-devs](https://github.com/Serverless-Devs/Serverless-Devs) is an open source and open serverless developer platform dedicated to providing developers with a powerful tool chain system. Through this platform, developers can not only experience multi cloud serverless products with one click and rapidly deploy serverless projects, but also manage projects in the whole life cycle of serverless applications, and combine serverless devs with other tools / platforms very simply and quickly to further improve the efficiency of R & D, operation and maintenance.

Add the Alibaba Cloud AccessKeyID & AccessKeySecret

```sh
npx s config add

**Examples:**

Example 1 (unknown):
```unknown

```

Example 2 (unknown):
```unknown

```

Example 3 (unknown):
```unknown

```

Example 4 (unknown):
```unknown
:::

## 2. Hello World

Edit `src/index.ts`.
```

---

## API

**URL:** llms-txt#api

Hono's API is simple.
Just composed by extended objects from Web Standards.
So, you can understand it well quickly.

In this section, we introduce API of Hono like below.

- Hono object
- About routing
- Context object
- About middleware

---

## App - Hono

**URL:** llms-txt#app---hono

**Contents:**
- Methods
- Not Found
- Error Handling
- fire()
- fetch()
- request()
- mount()
- strict mode
- router option
- Generics

`Hono` is the primary object.
It will be imported first and used until the end.

An instance of `Hono` has the following methods.

- app.**HTTP_METHOD**(\[path,\]handler|middleware...)
- app.**all**(\[path,\]handler|middleware...)
- app.**on**(method|method[], path|path[], handler|middleware...)
- app.**use**(\[path,\]middleware)
- app.**route**(path, \[app\])
- app.**basePath**(path)
- app.**notFound**(handler)
- app.**onError**(err, handler)
- app.**mount**(path, anotherApp)
- app.**fire**()
- app.**fetch**(request, env, event)
- app.**request**(path, options)

The first part of them is used for routing, please refer to the [routing section](/docs/api/routing).

`app.notFound` allows you to customize a Not Found Response.

:::warning
The `notFound` method is only called from the top-level app. For more information, see this [issue](https://github.com/honojs/hono/issues/3465#issuecomment-2381210165).
:::

`app.onError` allows you to handle uncaught errors and return a custom Response.

::: info
If both a parent app and its routes have `onError` handlers, the route-level handlers get priority.
:::

::: warning
**`app.fire()` is deprecated**. Use `fire()` from `hono/service-worker` instead. See the [Service Worker documentation](/docs/getting-started/service-worker) for details.
:::

`app.fire()` automatically adds a global `fetch` event listener.

This can be useful for environments that adhere to the [Service Worker API](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API), such as [non-ES module Cloudflare Workers](https://developers.cloudflare.com/workers/reference/migrate-to-module-workers/).

`app.fire()` executes the following for you:

`app.fetch` will be entry point of your application.

For Cloudflare Workers, you can use the following:

<!-- prettier-ignore -->

`request` is a useful method for testing.

You can pass a URL or pathname to send a GET request.
`app` will return a `Response` object.

You can also pass a `Request` object:

The `mount()` allows you to mount applications built with other frameworks into your Hono application.

Strict mode defaults to `true` and distinguishes the following routes.

- `/hello`
- `/hello/`

`app.get('/hello')` will not match `GET /hello/`.

By setting strict mode to `false`, both paths will be treated equally.

The `router` option specifies which router to use. The default router is `SmartRouter`. If you want to use `RegExpRouter`, pass it to a new `Hono` instance:

You can pass Generics to specify the types of Cloudflare Workers Bindings and variables used in `c.set`/`c.get`.

**Examples:**

Example 1 (unknown):
```unknown
## Methods

An instance of `Hono` has the following methods.

- app.**HTTP_METHOD**(\[path,\]handler|middleware...)
- app.**all**(\[path,\]handler|middleware...)
- app.**on**(method|method[], path|path[], handler|middleware...)
- app.**use**(\[path,\]middleware)
- app.**route**(path, \[app\])
- app.**basePath**(path)
- app.**notFound**(handler)
- app.**onError**(err, handler)
- app.**mount**(path, anotherApp)
- app.**fire**()
- app.**fetch**(request, env, event)
- app.**request**(path, options)

The first part of them is used for routing, please refer to the [routing section](/docs/api/routing).

## Not Found

`app.notFound` allows you to customize a Not Found Response.
```

Example 2 (unknown):
```unknown
:::warning
The `notFound` method is only called from the top-level app. For more information, see this [issue](https://github.com/honojs/hono/issues/3465#issuecomment-2381210165).
:::

## Error Handling

`app.onError` allows you to handle uncaught errors and return a custom Response.
```

Example 3 (unknown):
```unknown
::: info
If both a parent app and its routes have `onError` handlers, the route-level handlers get priority.
:::

## fire()

::: warning
**`app.fire()` is deprecated**. Use `fire()` from `hono/service-worker` instead. See the [Service Worker documentation](/docs/getting-started/service-worker) for details.
:::

`app.fire()` automatically adds a global `fetch` event listener.

This can be useful for environments that adhere to the [Service Worker API](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API), such as [non-ES module Cloudflare Workers](https://developers.cloudflare.com/workers/reference/migrate-to-module-workers/).

`app.fire()` executes the following for you:
```

Example 4 (unknown):
```unknown
## fetch()

`app.fetch` will be entry point of your application.

For Cloudflare Workers, you can use the following:
```

---

## AWS Lambda

**URL:** llms-txt#aws-lambda

**Contents:**
- 1. Setup
- 2. Hello World
- 3. Deploy
- Serve Binary data
- Access AWS Lambda Object
- Access RequestContext
  - Before v3.10.0 (deprecated)
- Lambda response streaming

AWS Lambda is a serverless platform by Amazon Web Services.
You can run your code in response to events and automatically manages the underlying compute resources for you.

Hono works on AWS Lambda with the Node.js 18+ environment.

When creating the application on AWS Lambda,
[CDK](https://docs.aws.amazon.com/cdk/v2/guide/home.html)
is useful to setup the functions such as IAM Role, API Gateway, and others.

Initialize your project with the `cdk` CLI.

Edit `lambda/index.ts`.

Edit `lib/my-app-stack.ts`.

Finally, run the command to deploy:

Hono supports binary data as a response.
In Lambda, base64 encoding is required to return binary data.
Once binary type is set to `Content-Type` header, Hono automatically encodes data to base64.

## Access AWS Lambda Object

In Hono, you can access the AWS Lambda Events and Context by binding the `LambdaEvent`, `LambdaContext` type and using `c.env`

## Access RequestContext

In Hono, you can access the AWS Lambda request context by binding the `LambdaEvent` type and using `c.env.event.requestContext`.

### Before v3.10.0 (deprecated)

you can access the AWS Lambda request context by binding the `ApiGatewayRequestContext` type and using `c.env.`

## Lambda response streaming

By changing the invocation mode of AWS Lambda, you can achieve [Streaming Response](https://aws.amazon.com/blogs/compute/introducing-aws-lambda-response-streaming/).

Typically, the implementation requires writing chunks to NodeJS.WritableStream using awslambda.streamifyResponse, but with the AWS Lambda Adaptor, you can achieve the traditional streaming response of Hono by using streamHandle instead of handle.

**Examples:**

Example 1 (unknown):
```unknown

```

Example 2 (unknown):
```unknown

```

Example 3 (unknown):
```unknown

```

Example 4 (unknown):
```unknown
:::

## 2. Hello World

Edit `lambda/index.ts`.
```

---

## Azure Functions

**URL:** llms-txt#azure-functions

**Contents:**
- 1. Install CLI
- 2. Setup
- 3. Hello World
- 4. Run
- 5. Deploy

[Azure Functions](https://azure.microsoft.com/en-us/products/functions) is a serverless platform from Microsoft Azure. You can run your code in response to events, and it automatically manages the underlying compute resources for you.

Hono was not designed for Azure Functions at first. But with [Azure Functions Adapter](https://github.com/Marplex/hono-azurefunc-adapter) it can run on it as well.

It works with Azure Functions **V4** running on Node.js 18 or above.

To create an Azure Function, you must first install [Azure Functions Core Tools](https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-cli-typescript?pivots=nodejs-model-v4#install-the-azure-functions-core-tools).

Follow this link for other OS:

- [Install the Azure Functions Core Tools | Microsoft Learn](https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-cli-typescript?pivots=nodejs-model-v4#install-the-azure-functions-core-tools)

Create a TypeScript Node.js V4 project in the current folder.

Change the default route prefix of the host. Add this property to the root json object of `host.json`:

::: info
The default Azure Functions route prefix is `/api`. If you don't change it as shown above, be sure to start all your Hono routes with `/api`
:::

Now you are ready to install Hono and the Azure Functions Adapter with:

Create `src/functions/httpTrigger.ts`:

Run the development server locally. Then, access `http://localhost:7071` in your Web browser.

::: info
Before you can deploy to Azure, you need to create some resources in your cloud infrastructure. Please visit the Microsoft documentation on [Create supporting Azure resources for your function](https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-cli-typescript?pivots=nodejs-model-v4&tabs=windows%2Cazure-cli%2Cbrowser#create-supporting-azure-resources-for-your-function)
:::

Build the project for deployment:

Deploy your project to the function app in Azure Cloud. Replace `<YourFunctionAppName>` with the name of your app.

**Examples:**

Example 1 (sh):
```sh
brew tap azure/functions
brew install azure-functions-core-tools@4
```

Example 2 (sh):
```sh
func init --typescript
```

Example 3 (json):
```json
"extensions": {
    "http": {
        "routePrefix": ""
    }
}
```

Example 4 (unknown):
```unknown

```

---

## Basic Auth Middleware

**URL:** llms-txt#basic-auth-middleware

**Contents:**
- Import
- Usage
- Options
  - <Badge type="danger" text="required" /> username: `string`
  - <Badge type="danger" text="required" /> password: `string`
  - <Badge type="info" text="optional" /> realm: `string`
  - <Badge type="info" text="optional" /> hashFunction: `Function`
  - <Badge type="info" text="optional" /> verifyUser: `(username: string, password: string, c: Context) => boolean | Promise<boolean>`
  - <Badge type="info" text="optional" /> invalidUserMessage: `string | object | MessageFunction`
- More Options

This middleware can apply Basic authentication to a specified path.
Implementing Basic authentication with Cloudflare Workers or other platforms is more complicated than it seems, but with this middleware, it's a breeze.

For more information about how the Basic auth scheme works under the hood, see the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication#basic_authentication_scheme).

To restrict to a specific route + method:

If you want to verify the user by yourself, specify the `verifyUser` option; returning `true` means it is accepted.

### <Badge type="danger" text="required" /> username: `string`

The username of the user who is authenticating.

### <Badge type="danger" text="required" /> password: `string`

The password value for the provided username to authenticate against.

### <Badge type="info" text="optional" /> realm: `string`

The domain name of the realm, as part of the returned WWW-Authenticate challenge header. The default is `"Secure Area"`.  
See more: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/WWW-Authenticate#directives

### <Badge type="info" text="optional" /> hashFunction: `Function`

A function to handle hashing for safe comparison of passwords.

### <Badge type="info" text="optional" /> verifyUser: `(username: string, password: string, c: Context) => boolean | Promise<boolean>`

The function to verify the user.

### <Badge type="info" text="optional" /> invalidUserMessage: `string | object | MessageFunction`

`MessageFunction` is `(c: Context) => string | object | Promise<string | object>`. The custom message if the user is invalid.

### <Badge type="info" text="optional" /> ...users: `{ username: string, password: string }[]`

### Defining Multiple Users

This middleware also allows you to pass arbitrary parameters containing objects defining more `username` and `password` pairs.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { basicAuth } from 'hono/basic-auth'
```

Example 2 (ts):
```ts
const app = new Hono()

app.use(
  '/auth/*',
  basicAuth({
    username: 'hono',
    password: 'acoolproject',
  })
)

app.get('/auth/page', (c) => {
  return c.text('You are authorized')
})
```

Example 3 (ts):
```ts
const app = new Hono()

app.get('/auth/page', (c) => {
  return c.text('Viewing page')
})

app.delete(
  '/auth/page',
  basicAuth({ username: 'hono', password: 'acoolproject' }),
  (c) => {
    return c.text('Page deleted')
  }
)
```

Example 4 (ts):
```ts
const app = new Hono()

app.use(
  basicAuth({
    verifyUser: (username, password, c) => {
      return (
        username === 'dynamic-user' && password === 'hono-password'
      )
    },
  })
)
```

---

## Bearer Auth Middleware

**URL:** llms-txt#bearer-auth-middleware

**Contents:**
- Import
- Usage
- Options
  - <Badge type="danger" text="required" /> token: `string` | `string[]`
  - <Badge type="info" text="optional" /> realm: `string`
  - <Badge type="info" text="optional" /> prefix: `string`
  - <Badge type="info" text="optional" /> headerName: `string`
  - <Badge type="info" text="optional" /> hashFunction: `Function`
  - <Badge type="info" text="optional" /> verifyToken: `(token: string, c: Context) => boolean | Promise<boolean>`
  - <Badge type="info" text="optional" /> noAuthenticationHeaderMessage: `string | object | MessageFunction`

The Bearer Auth Middleware provides authentication by verifying an API token in the Request header.
The HTTP clients accessing the endpoint will add the `Authorization` header with `Bearer {token}` as the header value.

Using `curl` from the terminal, it would look like this:

> [!NOTE]
> Your `token` must match the regex `/[A-Za-z0-9._~+/-]+=*/`, otherwise a 400 error will be returned. Notably, this regex accommodates both URL-safe Base64- and standard Base64-encoded JWTs. This middleware does not require the bearer token to be a JWT, just that it matches the above regex.

To restrict to a specific route + method:

To implement multiple tokens (E.g., any valid token can read but create/update/delete are restricted to a privileged token):

If you want to verify the value of the token yourself, specify the `verifyToken` option; returning `true` means it is accepted.

### <Badge type="danger" text="required" /> token: `string` | `string[]`

The string to validate the incoming bearer token against.

### <Badge type="info" text="optional" /> realm: `string`

The domain name of the realm, as part of the returned WWW-Authenticate challenge header. The default is `""`.
See more: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/WWW-Authenticate#directives

### <Badge type="info" text="optional" /> prefix: `string`

The prefix (or known as `schema`) for the Authorization header value. The default is `"Bearer"`.

### <Badge type="info" text="optional" /> headerName: `string`

The header name. The default value is `Authorization`.

### <Badge type="info" text="optional" /> hashFunction: `Function`

A function to handle hashing for safe comparison of authentication tokens.

### <Badge type="info" text="optional" /> verifyToken: `(token: string, c: Context) => boolean | Promise<boolean>`

The function to verify the token.

### <Badge type="info" text="optional" /> noAuthenticationHeaderMessage: `string | object | MessageFunction`

`MessageFunction` is `(c: Context) => string | object | Promise<string | object>`. The custom message if it does not have an authentication header.

### <Badge type="info" text="optional" /> invalidAuthenticationHeaderMessage: `string | object | MessageFunction`

The custom message if the authentication header is invalid.

### <Badge type="info" text="optional" /> invalidTokenMessage: `string | object | MessageFunction`

The custom message if the token is invalid.

**Examples:**

Example 1 (sh):
```sh
curl -H 'Authorization: Bearer honoiscool' http://localhost:8787/auth/page
```

Example 2 (ts):
```ts
import { Hono } from 'hono'
import { bearerAuth } from 'hono/bearer-auth'
```

Example 3 (ts):
```ts
const app = new Hono()

const token = 'honoiscool'

app.use('/api/*', bearerAuth({ token }))

app.get('/api/page', (c) => {
  return c.json({ message: 'You are authorized' })
})
```

Example 4 (ts):
```ts
const app = new Hono()

const token = 'honoiscool'

app.get('/api/page', (c) => {
  return c.json({ message: 'Read posts' })
})

app.post('/api/page', bearerAuth({ token }), (c) => {
  return c.json({ message: 'Created post!' }, 201)
})
```

---

## Benchmarks

**URL:** llms-txt#benchmarks

**Contents:**
- Routers
  - On Node.js
  - On Bun
- Cloudflare Workers
- Deno
- Bun

Benchmarks are only benchmarks, but they are important to us.

We measured the speeds of a bunch of JavaScript routers.
For example, `find-my-way` is a very fast router used inside Fastify.

- @medley/router
- find-my-way
- koa-tree-router
- trek-router
- express (includes handling)
- koa-router

First, we registered the following routing to each of our routers.
These are similar to those used in the real world.

Then we sent the Request to the endpoints like below.

Let's see the results.

The following screenshots show the results on Node.js.

![](/images/bench01.png)

![](/images/bench02.png)

![](/images/bench03.png)

![](/images/bench04.png)

![](/images/bench05.png)

![](/images/bench06.png)

![](/images/bench07.png)

![](/images/bench08.png)

The following screenshots show the results on Bun.

![](/images/bench09.png)

![](/images/bench10.png)

![](/images/bench11.png)

![](/images/bench12.png)

![](/images/bench13.png)

![](/images/bench14.png)

![](/images/bench15.png)

![](/images/bench16.png)

## Cloudflare Workers

**Hono is the fastest**, compared to other routers for Cloudflare Workers.

- Machine: Apple MacBook Pro, 32 GiB, M1 Pro
- Scripts: [benchmarks/handle-event](https://github.com/honojs/hono/tree/main/benchmarks/handle-event)

**Hono is the fastest**, compared to other frameworks for Deno.

- Machine: Apple MacBook Pro, 32 GiB, M1 Pro, Deno v1.22.0
- Scripts: [benchmarks/deno](https://github.com/honojs/hono/tree/main/benchmarks/deno)
- Method: `bombardier --fasthttp -d 10s -c 100 'http://localhost:8000/user/lookup/username/foo'`

| Framework |   Version    |                  Results |
| --------- | :----------: | -----------------------: |
| **Hono**  |    3.0.0     | **Requests/sec: 136112** |
| Fast      | 4.0.0-beta.1 |     Requests/sec: 103214 |
| Megalo    |    0.3.0     |      Requests/sec: 64597 |
| Faster    |     5.7      |      Requests/sec: 54801 |
| oak       |    10.5.1    |      Requests/sec: 43326 |
| opine     |    2.2.0     |      Requests/sec: 30700 |

Another benchmark result: [denosaurs/bench](https://github.com/denosaurs/bench)

Hono is one of the fastest frameworks for Bun.
You can see it below.

- [SaltyAom/bun-http-framework-benchmark](https://github.com/SaltyAom/bun-http-framework-benchmark)

**Examples:**

Example 1 (unknown):
```unknown
Then we sent the Request to the endpoints like below.
```

Example 2 (unknown):
```unknown
Let's see the results.

### On Node.js

The following screenshots show the results on Node.js.

![](/images/bench01.png)

![](/images/bench02.png)

![](/images/bench03.png)

![](/images/bench04.png)

![](/images/bench05.png)

![](/images/bench06.png)

![](/images/bench07.png)

![](/images/bench08.png)

### On Bun

The following screenshots show the results on Bun.

![](/images/bench09.png)

![](/images/bench10.png)

![](/images/bench11.png)

![](/images/bench12.png)

![](/images/bench13.png)

![](/images/bench14.png)

![](/images/bench15.png)

![](/images/bench16.png)

## Cloudflare Workers

**Hono is the fastest**, compared to other routers for Cloudflare Workers.

- Machine: Apple MacBook Pro, 32 GiB, M1 Pro
- Scripts: [benchmarks/handle-event](https://github.com/honojs/hono/tree/main/benchmarks/handle-event)
```

---

## Best Practices

**URL:** llms-txt#best-practices

**Contents:**
- Don't make "Controllers" when possible
- `factory.createHandlers()` in `hono/factory`
- Building a larger application
  - If you want to use RPC features

Hono is very flexible. You can write your app as you like.
However, there are best practices that are better to follow.

## Don't make "Controllers" when possible

When possible, you should not create "Ruby on Rails-like Controllers".

The issue is related to types. For example, the path parameter cannot be inferred in the Controller without writing complex generics.

Therefore, you don't need to create RoR-like controllers and should write handlers directly after path definitions.

## `factory.createHandlers()` in `hono/factory`

If you still want to create a RoR-like Controller, use `factory.createHandlers()` in [`hono/factory`](/docs/helpers/factory). If you use this, type inference will work correctly.

## Building a larger application

Use `app.route()` to build a larger application without creating "Ruby on Rails-like Controllers".

If your application has `/authors` and `/books` endpoints and you wish to separate files from `index.ts`, create `authors.ts` and `books.ts`.

Then, import them and mount on the paths `/authors` and `/books` with `app.route()`.

### If you want to use RPC features

The code above works well for normal use cases.
However, if you want to use the `RPC` feature, you can get the correct type by chaining as follows.

If you pass the type of the `app` to `hc`, it will get the correct type.

For more detailed information, please see [the RPC page](/docs/guides/rpc#using-rpc-with-larger-applications).

**Examples:**

Example 1 (ts):
```ts
// 🙁
// A RoR-like Controller
const booksList = (c: Context) => {
  return c.json('list books')
}

app.get('/books', booksList)
```

Example 2 (ts):
```ts
// 🙁
// A RoR-like Controller
const bookPermalink = (c: Context) => {
  const id = c.req.param('id') // Can't infer the path param
  return c.json(`get ${id}`)
}
```

Example 3 (ts):
```ts
// 😃
app.get('/books/:id', (c) => {
  const id = c.req.param('id') // Can infer the path param
  return c.json(`get ${id}`)
})
```

Example 4 (ts):
```ts
import { createFactory } from 'hono/factory'
import { logger } from 'hono/logger'

// ...

// 😃
const factory = createFactory()

const middleware = factory.createMiddleware(async (c, next) => {
  c.set('foo', 'bar')
  await next()
})

const handlers = factory.createHandlers(logger(), middleware, (c) => {
  return c.json(c.var.foo)
})

app.get('/api', ...handlers)
```

---

## Body Limit Middleware

**URL:** llms-txt#body-limit-middleware

**Contents:**
- Import
- Usage
- Options
  - <Badge type="danger" text="required" /> maxSize: `number`
  - <Badge type="info" text="optional" /> onError: `OnError`
- Usage with Bun for large requests

The Body Limit Middleware can limit the file size of the request body.

This middleware first uses the value of the `Content-Length` header in the request, if present.
If it is not set, it reads the body in the stream and executes an error handler if it is larger than the specified file size.

### <Badge type="danger" text="required" /> maxSize: `number`

The maximum file size of the file you want to limit. The default is `100 * 1024` - `100kb`.

### <Badge type="info" text="optional" /> onError: `OnError`

The error handler to be invoked if the specified file size is exceeded.

## Usage with Bun for large requests

If the Body Limit Middleware is used explicitly to allow a request body larger than the default, it might be necessary to make changes to your `Bun.serve` configuration accordingly. [At the time of writing](https://github.com/oven-sh/bun/blob/f2cfa15e4ef9d730fc6842ad8b79fb7ab4c71cb9/packages/bun-types/bun.d.ts#L2191), `Bun.serve`'s default request body limit is 128MiB. If you set Hono's Body Limit Middleware to a value bigger than that, your requests will still fail and, additionally, the `onError` handler specified in the middleware will not be called. This is because `Bun.serve()` will set the status code to `413` and terminate the connection before passing the request to Hono.

If you want to accept requests larger than 128MiB with Hono and Bun, you need to set the limit for Bun as well:

or, depending on your setup:

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { bodyLimit } from 'hono/body-limit'
```

Example 2 (ts):
```ts
const app = new Hono()

app.post(
  '/upload',
  bodyLimit({
    maxSize: 50 * 1024, // 50kb
    onError: (c) => {
      return c.text('overflow :(', 413)
    },
  }),
  async (c) => {
    const body = await c.req.parseBody()
    if (body['file'] instanceof File) {
      console.log(`Got file sized: ${body['file'].size}`)
    }
    return c.text('pass :)')
  }
)
```

Example 3 (ts):
```ts
export default {
  port: process.env['PORT'] || 3000,
  fetch: app.fetch,
  maxRequestBodySize: 1024 * 1024 * 200, // your value here
}
```

Example 4 (ts):
```ts
Bun.serve({
  fetch(req, server) {
    return app.fetch(req, { ip: server.requestIP(req) })
  },
  maxRequestBodySize: 1024 * 1024 * 200, // your value here
})
```

---

## Bun

**URL:** llms-txt#bun

**Contents:**
- 1. Install Bun
- 2. Setup
  - 2.1. Setup a new project
  - 2.2. Setup an existing project
- 3. Hello World
- 4. Run
- Change port number
- Serve static files
  - `rewriteRequestPath`
  - `mimes`

[Bun](https://bun.com) is another JavaScript runtime. It's not Node.js or Deno. Bun includes a trans compiler, we can write the code with TypeScript.
Hono also works on Bun.

To install `bun` command, follow the instruction in [the official web site](https://bun.com).

### 2.1. Setup a new project

A starter for Bun is available. Start your project with "bun create" command.
Select `bun` template for this example.

Move into my-app and install the dependencies.

### 2.2. Setup an existing project

On an existing Bun project, we only need to install `hono` dependencies on the project root directory via

"Hello World" script is below. Almost the same as writing on other platforms.

Then, access `http://localhost:3000` in your browser.

## Change port number

You can specify the port number with exporting the `port`.

<!-- prettier-ignore -->

## Serve static files

To serve static files, use `serveStatic` imported from `hono/bun`.

For the above code, it will work well with the following directory structure.

### `rewriteRequestPath`

If you want to map `http://localhost:3000/static/*` to `./statics`, you can use the `rewriteRequestPath` option:

You can add MIME types with `mimes`:

You can specify handling when the requested file is found with `onFound`:

You can specify handling when the requested file is not found with `onNotFound`:

The `precompressed` option checks if files with extensions like `.br` or `.gz` are available and serves them based on the `Accept-Encoding` header. It prioritizes Brotli, then Zstd, and Gzip. If none are available, it serves the original file.

You can use `bun:test` for testing on Bun.

Then, run the command.

**Examples:**

Example 1 (sh):
```sh
bun create hono@latest my-app
```

Example 2 (sh):
```sh
cd my-app
bun install
```

Example 3 (sh):
```sh
bun add hono
```

Example 4 (ts):
```ts
import { Hono } from 'hono'

const app = new Hono()
app.get('/', (c) => c.text('Hello Bun!'))

export default app
```

---

## Cache Middleware

**URL:** llms-txt#cache-middleware

**Contents:**
- Import
- Usage
- Options
  - <Badge type="danger" text="required" /> cacheName: `string` | `(c: Context) => string` | `Promise<string>`
  - <Badge type="info" text="optional" /> wait: `boolean`
  - <Badge type="info" text="optional" /> cacheControl: `string`
  - <Badge type="info" text="optional" /> vary: `string` | `string[]`
  - <Badge type="info" text="optional" /> keyGenerator: `(c: Context) => string | Promise<string>`
  - <Badge type="info" text="optional" /> cacheableStatusCodes: `number[]`

The Cache middleware uses the Web Standards' [Cache API](https://developer.mozilla.org/en-US/docs/Web/API/Cache).

The Cache middleware currently supports Cloudflare Workers projects using custom domains and Deno projects using [Deno 1.26+](https://github.com/denoland/deno/releases/tag/v1.26.0). Also available with Deno Deploy.

Cloudflare Workers respects the `Cache-Control` header and return cached responses. For details, refer to [Cache on Cloudflare Docs](https://developers.cloudflare.com/workers/runtime-apis/cache/). Deno does not respect headers, so if you need to update the cache, you will need to implement your own mechanism.

See [Usage](#usage) below for instructions on each platform.

### <Badge type="danger" text="required" /> cacheName: `string` | `(c: Context) => string` | `Promise<string>`

The name of the cache. Can be used to store multiple caches with different identifiers.

### <Badge type="info" text="optional" /> wait: `boolean`

A boolean indicating if Hono should wait for the Promise of the `cache.put` function to resolve before continuing with the request. _Required to be true for the Deno environment_. The default is `false`.

### <Badge type="info" text="optional" /> cacheControl: `string`

A string of directives for the `Cache-Control` header. See the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control) for more information. When this option is not provided, no `Cache-Control` header is added to requests.

### <Badge type="info" text="optional" /> vary: `string` | `string[]`

Sets the `Vary` header in the response. If the original response header already contains a `Vary` header, the values are merged, removing any duplicates. Setting this to `*` will result in an error. For more details on the Vary header and its implications for caching strategies, refer to the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Vary).

### <Badge type="info" text="optional" /> keyGenerator: `(c: Context) => string | Promise<string>`

Generates keys for every request in the `cacheName` store. This can be used to cache data based on request parameters or context parameters. The default is `c.req.url`.

### <Badge type="info" text="optional" /> cacheableStatusCodes: `number[]`

An array of status codes that should be cached. The default is `[200]`. Use this option to cache responses with specific status codes.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { cache } from 'hono/cache'
```

Example 2 (unknown):
```unknown

```

Example 3 (unknown):
```unknown
:::

## Options

### <Badge type="danger" text="required" /> cacheName: `string` | `(c: Context) => string` | `Promise<string>`

The name of the cache. Can be used to store multiple caches with different identifiers.

### <Badge type="info" text="optional" /> wait: `boolean`

A boolean indicating if Hono should wait for the Promise of the `cache.put` function to resolve before continuing with the request. _Required to be true for the Deno environment_. The default is `false`.

### <Badge type="info" text="optional" /> cacheControl: `string`

A string of directives for the `Cache-Control` header. See the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control) for more information. When this option is not provided, no `Cache-Control` header is added to requests.

### <Badge type="info" text="optional" /> vary: `string` | `string[]`

Sets the `Vary` header in the response. If the original response header already contains a `Vary` header, the values are merged, removing any duplicates. Setting this to `*` will result in an error. For more details on the Vary header and its implications for caching strategies, refer to the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Vary).

### <Badge type="info" text="optional" /> keyGenerator: `(c: Context) => string | Promise<string>`

Generates keys for every request in the `cacheName` store. This can be used to cache data based on request parameters or context parameters. The default is `c.req.url`.

### <Badge type="info" text="optional" /> cacheableStatusCodes: `number[]`

An array of status codes that should be cached. The default is `[200]`. Use this option to cache responses with specific status codes.
```

---

## Client Components

**URL:** llms-txt#client-components

**Contents:**
- Counter example
- `render()`
- Hooks compatible with React
- `startViewTransition()` family
  - 1. An easiest example
  - 2. Using `viewTransition()` with `keyframes()`
  - 3. Using `useViewTransition`
- The `hono/jsx/dom` runtime

`hono/jsx` supports not only server side but also client side. This means that it is possible to create an interactive UI that runs in the browser. We call it Client Components or `hono/jsx/dom`.

It is fast and very small. The counter program in `hono/jsx/dom` is only 2.8KB with Brotli compression. But, 47.8KB for React.

This section introduces Client Components-specific features.

Here is an example of a simple counter, the same code works as in React.

You can use `render()` to insert JSX components within a specified HTML element.

## Hooks compatible with React

hono/jsx/dom has Hooks that are compatible or partially compatible with React. You can learn about these APIs by looking at [the React documentation](https://react.dev/reference/react/hooks).

- `useState()`
- `useEffect()`
- `useRef()`
- `useCallback()`
- `use()`
- `startTransition()`
- `useTransition()`
- `useDeferredValue()`
- `useMemo()`
- `useLayoutEffect()`
- `useReducer()`
- `useDebugValue()`
- `createElement()`
- `memo()`
- `isValidElement()`
- `useId()`
- `createRef()`
- `forwardRef()`
- `useImperativeHandle()`
- `useSyncExternalStore()`
- `useInsertionEffect()`
- `useFormStatus()`
- `useActionState()`
- `useOptimistic()`

## `startViewTransition()` family

The `startViewTransition()` family contains original hooks and functions to handle [View Transitions API](https://developer.mozilla.org/en-US/docs/Web/API/View_Transitions_API) easily. The followings are examples of how to use them.

### 1. An easiest example

You can write a transition using the `document.startViewTransition` shortly with the `startViewTransition()`.

### 2. Using `viewTransition()` with `keyframes()`

The `viewTransition()` function allows you to get the unique `view-transition-name`.

You can use it with the `keyframes()`, The `::view-transition-old()` is converted to `::view-transition-old(${uniqueName))`.

### 3. Using `useViewTransition`

If you want to change the style only during the animation. You can use `useViewTransition()`. This hook returns the `[boolean, (callback: () => void) => void]`, and they are the `isUpdating` flag and the `startViewTransition()` function.

When this hook is used, the Component is evaluated at the following two times.

- Inside the callback of a call to `startViewTransition()`.
- When [the `finish` promise becomes fulfilled](https://developer.mozilla.org/en-US/docs/Web/API/ViewTransition/finished)

## The `hono/jsx/dom` runtime

There is a small JSX Runtime for Client Components. Using this will result in smaller bundled results than using `hono/jsx`. Specify `hono/jsx/dom` in `tsconfig.json`. For Deno, modify the deno.json.

Alternatively, you can specify `hono/jsx/dom` in the esbuild transform options in `vite.config.ts`.

**Examples:**

Example 1 (tsx):
```tsx
import { useState } from 'hono/jsx'
import { render } from 'hono/jsx/dom'

function Counter() {
  const [count, setCount] = useState(0)
  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  )
}

function App() {
  return (
    <html>
      <body>
        <Counter />
      </body>
    </html>
  )
}

const root = document.getElementById('root')
render(<App />, root)
```

Example 2 (tsx):
```tsx
render(<Component />, container)
```

Example 3 (tsx):
```tsx
import { useState, startViewTransition } from 'hono/jsx'
import { css, Style } from 'hono/css'

export default function App() {
  const [showLargeImage, setShowLargeImage] = useState(false)
  return (
    <>
      <Style />
      <button
        onClick={() =>
          startViewTransition(() =>
            setShowLargeImage((state) => !state)
          )
        }
      >
        Click!
      </button>
      <div>
        {!showLargeImage ? (
          <img src='https://hono.dev/images/logo.png' />
        ) : (
          <div
            class={css`
              background: url('https://hono.dev/images/logo-large.png');
              background-size: contain;
              background-repeat: no-repeat;
              background-position: center;
              width: 600px;
              height: 600px;
            `}
          ></div>
        )}
      </div>
    </>
  )
}
```

Example 4 (tsx):
```tsx
import { useState, startViewTransition } from 'hono/jsx'
import { viewTransition } from 'hono/jsx/dom/css'
import { css, keyframes, Style } from 'hono/css'

const rotate = keyframes`
  from {
    rotate: 0deg;
  }
  to {
    rotate: 360deg;
  }
`

export default function App() {
  const [showLargeImage, setShowLargeImage] = useState(false)
  const [transitionNameClass] = useState(() =>
    viewTransition(css`
      ::view-transition-old() {
        animation-name: ${rotate};
      }
      ::view-transition-new() {
        animation-name: ${rotate};
      }
    `)
  )
  return (
    <>
      <Style />
      <button
        onClick={() =>
          startViewTransition(() =>
            setShowLargeImage((state) => !state)
          )
        }
      >
        Click!
      </button>
      <div>
        {!showLargeImage ? (
          <img src='https://hono.dev/images/logo.png' />
        ) : (
          <div
            class={css`
              ${transitionNameClass}
              background: url('https://hono.dev/images/logo-large.png');
              background-size: contain;
              background-repeat: no-repeat;
              background-position: center;
              width: 600px;
              height: 600px;
            `}
          ></div>
        )}
      </div>
    </>
  )
}
```

---

## Cloudflare Pages

**URL:** llms-txt#cloudflare-pages

**Contents:**
- 1. Setup
- 2. Hello World
- 3. Run
- 4. Deploy
  - Deploy via the Cloudflare dashboard with GitHub
- Bindings
  - Create `wrangler.toml`
  - Create KV
  - Edit `vite.config.ts`
  - Use Bindings in your application

[Cloudflare Pages](https://pages.cloudflare.com) is an edge platform for full-stack web applications.
It serves static files and dynamic content provided by Cloudflare Workers.

Hono fully supports Cloudflare Pages.
It introduces a delightful developer experience. Vite's dev server is fast, and deploying with Wrangler is super quick.

A starter for Cloudflare Pages is available.
Start your project with "create-hono" command.
Select `cloudflare-pages` template for this example.

Move into `my-app` and install the dependencies.

Below is a basic directory structure.

Edit `src/index.tsx` like the following:

Run the development server locally. Then, access `http://localhost:5173` in your Web browser.

If you have a Cloudflare account, you can deploy to Cloudflare. In `package.json`, `$npm_execpath` needs to be changed to your package manager of choice.

### Deploy via the Cloudflare dashboard with GitHub

1. Log in to the [Cloudflare dashboard](https://dash.cloudflare.com) and select your account.
2. In Account Home, select Workers & Pages > Create application > Pages > Connect to Git.
3. Authorize your GitHub account, and select the repository. In Set up builds and deployments, provide the following information:

| Configuration option | Value           |
| -------------------- | --------------- |
| Production branch    | `main`          |
| Build command        | `npm run build` |
| Build directory      | `dist`          |

You can use Cloudflare Bindings like Variables, KV, D1, and others.
In this section, let's use Variables and KV.

### Create `wrangler.toml`

First, create `wrangler.toml` for local Bindings:

Edit `wrangler.toml`. Specify Variable with the name `MY_NAME`.

Next, make the KV. Run the following `wrangler` command:

Note down the `preview_id` as the following output:

Specify `preview_id` with the name of Bindings, `MY_KV`:

### Edit `vite.config.ts`

Edit the `vite.config.ts`:

### Use Bindings in your application

Use Variable and KV in your application. Set the types.

For Cloudflare Pages, you will use `wrangler.toml` for local development, but for production, you will set up Bindings in the dashboard.

You can write client-side scripts and import them into your application using Vite's features.
If `/src/client.ts` is the entry point for the client, simply write it in the script tag.
Additionally, `import.meta.env.PROD` is useful for detecting whether it's running on a dev server or in the build phase.

In order to build the script properly, you can use the example config file `vite.config.ts` as shown below.

You can run the following command to build the server and client script.

## Cloudflare Pages Middleware

Cloudflare Pages uses its own [middleware](https://developers.cloudflare.com/pages/functions/middleware/) system that is different from Hono's middleware. You can enable it by exporting `onRequest` in a file named `_middleware.ts` like this:

Using `handleMiddleware`, you can use Hono's middleware as Cloudflare Pages middleware.

You can also use built-in and 3rd party middleware for Hono. For example, to add Basic Authentication, you can use [Hono's Basic Authentication Middleware](/docs/middleware/builtin/basic-auth).

If you want to apply multiple middleware, you can write it like this:

### Accessing `EventContext`

You can access [`EventContext`](https://developers.cloudflare.com/pages/functions/api-reference/#eventcontext) object via `c.env` in `handleMiddleware`.

Then, you can access the data value in via `c.env.eventContext` in the handler:

**Examples:**

Example 1 (unknown):
```unknown

```

Example 2 (unknown):
```unknown

```

Example 3 (unknown):
```unknown

```

Example 4 (unknown):
```unknown

```

---

## Cloudflare Workers

**URL:** llms-txt#cloudflare-workers

**Contents:**
- 1. Setup
- 2. Hello World
- 3. Run
  - Change port number
- 4. Deploy
- Using Hono with other event handlers
- Serve static files
- Types
- Testing
- Bindings

[Cloudflare Workers](https://workers.cloudflare.com) is a JavaScript edge runtime on Cloudflare CDN.

You can develop the application locally and publish it with a few commands using [Wrangler](https://developers.cloudflare.com/workers/wrangler/).
Wrangler includes trans compiler, so we can write the code with TypeScript.

Let’s make your first application for Cloudflare Workers with Hono.

A starter for Cloudflare Workers is available.
Start your project with "create-hono" command.
Select `cloudflare-workers` template for this example.

Move to `my-app` and install the dependencies.

Edit `src/index.ts` like below.

Run the development server locally. Then, access `http://localhost:8787` in your web browser.

### Change port number

If you need to change the port number you can follow the instructions here to update `wrangler.toml` / `wrangler.json` / `wrangler.jsonc` files:
[Wrangler Configuration](https://developers.cloudflare.com/workers/wrangler/configuration/#local-development-settings)

Or, you can follow the instructions here to set CLI options:
[Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/commands/#dev)

If you have a Cloudflare account, you can deploy to Cloudflare. In `package.json`, `$npm_execpath` needs to be changed to your package manager of choice.

## Using Hono with other event handlers

You can integrate Hono with other event handlers (such as `scheduled`) in _Module Worker mode_.

To do this, export `app.fetch` as the module's `fetch` handler, and then implement other handlers as needed:

## Serve static files

If you want to serve static files, you can use [the Static Assets feature](https://developers.cloudflare.com/workers/static-assets/) of Cloudflare Workers. Specify the directory for the files in `wrangler.toml`:

Then create the `public` directory and place the files there. For instance, `./public/static/hello.txt` will be served as `/static/hello.txt`.

You have to install `@cloudflare/workers-types` if you want to have workers types.

For testing, we recommend using `@cloudflare/vitest-pool-workers`.
Refer to [examples](https://github.com/honojs/examples) for setting it up.

If there is the application below.

We can test if it returns "_200 OK_" Response with this code.

In the Cloudflare Workers, we can bind the environment values, KV namespace, R2 bucket, or Durable Object. You can access them in `c.env`. It will have the types if you pass the "_type struct_" for the bindings to the `Hono` as generics.

## Using Variables in Middleware

This is the only case for Module Worker mode.
If you want to use Variables or Secret Variables in Middleware, for example, "username" or "password" in Basic Authentication Middleware, you need to write like the following.

The same is applied to Bearer Authentication Middleware, JWT Authentication, or others.

## Deploy from GitHub Actions

Before deploying code to Cloudflare via CI, you need a Cloudflare token. You can manage it from [User API Tokens](https://dash.cloudflare.com/profile/api-tokens).

If it's a newly created token, select the **Edit Cloudflare Workers** template, if you already have another token, make sure the token has the corresponding permissions(No, token permissions are not shared between Cloudflare Pages and Cloudflare Workers).

then go to your GitHub repository settings dashboard: `Settings->Secrets and variables->Actions->Repository secrets`, and add a new secret with the name `CLOUDFLARE_API_TOKEN`.

then create `.github/workflows/deploy.yml` in your Hono project root folder, paste the following code:

then edit `wrangler.toml`, and add this code after `compatibility_date` line.

Everything is ready! Now push the code and enjoy it.

## Load env when local development

To configure the environment variables for local development, create a `.dev.vars` file or a `.env` file in the root directory of the project.
These files should be formatted using the [dotenv](https://hexdocs.pm/dotenvy/dotenv-file-format.html) syntax. For example:

> For more about this section you can find in the Cloudflare documentation:
> https://developers.cloudflare.com/workers/wrangler/configuration/#secrets

Then we use the `c.env.*` to get the environment variables in our code.

::: info
By default, `process.env` is not available in Cloudflare Workers, so it is recommended to get environment variables from `c.env`. If you want to use it, you need to enable [`nodejs_compat_populate_process_env`](https://developers.cloudflare.com/workers/configuration/compatibility-flags/#enable-auto-populating-processenv) flag. You can also import `env` from `cloudflare:workers`. For details, please see [How to access `env` on Cloudflare docs](https://developers.cloudflare.com/workers/runtime-apis/bindings/#how-to-access-env)
:::

Before you deploy your project to Cloudflare, remember to set the environment variable/secrets in the Cloudflare Workers project's configuration.

> For more about this section you can find in the Cloudflare documentation:
> https://developers.cloudflare.com/workers/configuration/environment-variables/#add-environment-variables-via-the-dashboard

**Examples:**

Example 1 (unknown):
```unknown

```

Example 2 (unknown):
```unknown

```

Example 3 (unknown):
```unknown

```

Example 4 (unknown):
```unknown

```

---

## Combine Middleware

**URL:** llms-txt#combine-middleware

**Contents:**
- Import
- Usage
  - some
  - every
  - except

Combine Middleware combines multiple middleware functions into a single middleware. It provides three functions:

- `some` - Runs only one of the given middleware.
- `every` - Runs all given middleware.
- `except` - Runs all given middleware only if a condition is not met.

Here's an example of complex access control rules using Combine Middleware.

Runs the first middleware that returns true. Middleware is applied in order, and if any middleware exits successfully, subsequent middleware will not run.

Runs all middleware and stops if any of them fail. Middleware is applied in order, and if any middleware throws an error, subsequent middleware will not run.

Runs all middleware except when the condition is met. You can pass a string or function as the condition. If multiple targets need to be matched, pass them as an array.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { some, every, except } from 'hono/combine'
```

Example 2 (ts):
```ts
import { Hono } from 'hono'
import { bearerAuth } from 'hono/bearer-auth'
import { getConnInfo } from 'hono/cloudflare-workers'
import { every, some } from 'hono/combine'
import { ipRestriction } from 'hono/ip-restriction'
import { rateLimit } from '@/my-rate-limit'

const app = new Hono()

app.use(
  '*',
  some(
    every(
      ipRestriction(getConnInfo, { allowList: ['192.168.0.2'] }),
      bearerAuth({ token })
    ),
    // If both conditions are met, rateLimit will not execute.
    rateLimit()
  )
)

app.get('/', (c) => c.text('Hello Hono!'))
```

Example 3 (ts):
```ts
import { some } from 'hono/combine'
import { bearerAuth } from 'hono/bearer-auth'
import { myRateLimit } from '@/rate-limit'

// If client has a valid token, skip rate limiting.
// Otherwise, apply rate limiting.
app.use(
  '/api/*',
  some(bearerAuth({ token }), myRateLimit({ limit: 100 }))
)
```

Example 4 (ts):
```ts
import { some, every } from 'hono/combine'
import { bearerAuth } from 'hono/bearer-auth'
import { myCheckLocalNetwork } from '@/check-local-network'
import { myRateLimit } from '@/rate-limit'

// If client is in local network, skip authentication and rate limiting.
// Otherwise, apply authentication and rate limiting.
app.use(
  '/api/*',
  some(
    myCheckLocalNetwork(),
    every(bearerAuth({ token }), myRateLimit({ limit: 100 }))
  )
)
```

---

## Compress Middleware

**URL:** llms-txt#compress-middleware

**Contents:**
- Import
- Usage
- Options
  - <Badge type="info" text="optional" /> encoding: `'gzip'` | `'deflate'`
  - <Badge type="info" text="optional" /> threshold: `number`

This middleware compresses the response body, according to `Accept-Encoding` request header.

::: info
**Note**: On Cloudflare Workers and Deno Deploy, the response body will be compressed automatically, so there is no need to use this middleware.

**Bun**: This middleware uses `CompressionStream` which is not yet supported in bun.
:::

### <Badge type="info" text="optional" /> encoding: `'gzip'` | `'deflate'`

The compression scheme to allow for response compression. Either `gzip` or `deflate`. If not defined, both are allowed and will be used based on the `Accept-Encoding` header. `gzip` is prioritized if this option is not provided and the client provides both in the `Accept-Encoding` header.

### <Badge type="info" text="optional" /> threshold: `number`

The minimum size in bytes to compress. Defaults to 1024 bytes.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { compress } from 'hono/compress'
```

Example 2 (ts):
```ts
const app = new Hono()

app.use(compress())
```

---

## ConnInfo Helper

**URL:** llms-txt#conninfo-helper

**Contents:**
- Import
- Usage
- Type Definitions

The ConnInfo Helper helps you to get the connection information. For example, you can get the client's remote address easily.

The type definitions of the values that you can get from `getConnInfo()` are the following:

**Examples:**

Example 1 (unknown):
```unknown

```

Example 2 (unknown):
```unknown

```

Example 3 (unknown):
```unknown

```

Example 4 (unknown):
```unknown

```

---

## Context

**URL:** llms-txt#context

**Contents:**
- req
- status()
- header()
- body()
- text()
- json()
- html()
- notFound()
- redirect()
- res

The `Context` object is instantiated for each request and kept until the response is returned. You can put values in it, set headers and a status code you want to return, and access HonoRequest and Response objects.

`req` is an instance of HonoRequest. For more details, see [HonoRequest](/docs/api/request).

You can set an HTTP status code with `c.status()`. The default is `200`. You don't have to use `c.status()` if the code is `200`.

You can set HTTP Headers for the response.

Return an HTTP response.

::: info
**Note**: When returning text or HTML, it is recommended to use `c.text()` or `c.html()`.
:::

You can also write the following.

The response is the same `Response` object as below.

Render text as `Content-Type:text/plain`.

Render JSON as `Content-Type:application/json`.

Render HTML as `Content-Type:text/html`.

Return a `Not Found` Response. You can customize it with [`app.notFound()`](/docs/api/hono#not-found).

Redirect, default status code is `302`.

You can access the Response object that will be returned.

Get and set arbitrary key-value pairs, with a lifetime of the current request. This allows passing specific values between middleware or from middleware to route handlers.

Pass the `Variables` as Generics to the constructor of `Hono` to make it type-safe.

The value of `c.set` / `c.get` are retained only within the same request. They cannot be shared or persisted across different requests.

You can also access the value of a variable with `c.var`.

If you want to create the middleware which provides a custom method,
write like the following:

If you want to use the middleware in multiple handlers, you can use `app.use()`.
Then, you have to pass the `Env` as Generics to the constructor of `Hono` to make it type-safe.

## render() / setRenderer()

You can set a layout using `c.setRenderer()` within a custom middleware.

Then, you can utilize `c.render()` to create responses within this layout.

The output of which will be:

Additionally, this feature offers the flexibility to customize arguments.
To ensure type safety, types can be defined as:

Here's an example of how you can use this:

You can access Cloudflare Workers' specific [ExecutionContext](https://developers.cloudflare.com/workers/runtime-apis/context/).

You can access Cloudflare Workers' specific `FetchEvent`. This was used in "Service Worker" syntax. But, it is not recommended now.

In Cloudflare Workers Environment variables, secrets, KV namespaces, D1 database, R2 bucket etc. that are bound to a worker are known as bindings.
Regardless of type, bindings are always available as global variables and can be accessed via the context `c.env.BINDING_KEY`.

If the Handler throws an error, the error object is placed in `c.error`.
You can access it in your middleware.

## ContextVariableMap

For instance, if you wish to add type definitions to variables when a specific middleware is used, you can extend `ContextVariableMap`. For example:

You can then utilize this in your middleware:

In a handler, the variable is inferred as the proper type:

**Examples:**

Example 1 (unknown):
```unknown
## status()

You can set an HTTP status code with `c.status()`. The default is `200`. You don't have to use `c.status()` if the code is `200`.
```

Example 2 (unknown):
```unknown
## header()

You can set HTTP Headers for the response.
```

Example 3 (unknown):
```unknown
## body()

Return an HTTP response.

::: info
**Note**: When returning text or HTML, it is recommended to use `c.text()` or `c.html()`.
:::
```

Example 4 (unknown):
```unknown
You can also write the following.
```

---

## Context Storage Middleware

**URL:** llms-txt#context-storage-middleware

**Contents:**
- Import
- Usage

The Context Storage Middleware stores the Hono `Context` in the `AsyncLocalStorage`, to make it globally accessible.

::: info
**Note** This middleware uses `AsyncLocalStorage`. The runtime should support it.

**Cloudflare Workers**: To enable `AsyncLocalStorage`, add the [`nodejs_compat` or `nodejs_als` flag](https://developers.cloudflare.com/workers/configuration/compatibility-dates/#nodejs-compatibility-flag) to your `wrangler.toml` file.
:::

The `getContext()` will return the current Context object if the `contextStorage()` is applied as a middleware.

On Cloudflare Workers, you can access the bindings outside the handler.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { contextStorage, getContext } from 'hono/context-storage'
```

Example 2 (ts):
```ts
type Env = {
  Variables: {
    message: string
  }
}

const app = new Hono<Env>()

app.use(contextStorage())

app.use(async (c, next) => {
  c.set('message', 'Hello!')
  await next()
})

// You can access the variable outside the handler.
const getMessage = () => {
  return getContext<Env>().var.message
}

app.get('/', (c) => {
  return c.text(getMessage())
})
```

Example 3 (ts):
```ts
type Env = {
  Bindings: {
    KV: KVNamespace
  }
}

const app = new Hono<Env>()

app.use(contextStorage())

const setKV = (value: string) => {
  return getContext<Env>().env.KV.put('key', value)
}
```

---

## Cookie Helper

**URL:** llms-txt#cookie-helper

**Contents:**
- Import
- Usage
  - Regular cookies
  - Signed cookies
  - Cookie Generation
- Options
  - `setCookie` & `setSignedCookie`
  - `deleteCookie`
- `__Secure-` and `__Host-` prefix
- Following the best practices

The Cookie Helper provides an easy interface to manage cookies, enabling developers to set, parse, and delete cookies seamlessly.

**NOTE**: Setting and retrieving signed cookies returns a Promise due to the async nature of the WebCrypto API, which is used to create HMAC SHA-256 signatures.

### Cookie Generation

`generateCookie` and `generateSignedCookie` functions allow you to create cookie strings directly without setting them in the response headers.

#### `generateCookie`

#### `generateSignedCookie`

**Note**: Unlike `setCookie` and `setSignedCookie`, these functions only generate the cookie strings. You need to manually set them in headers if needed.

### `setCookie` & `setSignedCookie`

- domain: `string`
- expires: `Date`
- httpOnly: `boolean`
- maxAge: `number`
- path: `string`
- secure: `boolean`
- sameSite: `'Strict'` | `'Lax'` | `'None'`
- priority: `'Low' | 'Medium' | 'High'`
- prefix: `secure` | `'host'`
- partitioned: `boolean`

- path: `string`
- secure: `boolean`
- domain: `string`

`deleteCookie` returns the deleted value:

## `__Secure-` and `__Host-` prefix

The Cookie helper supports `__Secure-` and `__Host-` prefix for cookies names.

If you want to verify if the cookie name has a prefix, specify the prefix option.

Also, if you wish to specify a prefix when setting the cookie, specify a value for the prefix option.

## Following the best practices

A New Cookie RFC (a.k.a cookie-bis) and CHIPS include some best practices for Cookie settings that developers should follow.

- [RFC6265bis-13](https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-rfc6265bis-13)
  - `Max-Age`/`Expires` limitation
  - `__Host-`/`__Secure-` prefix limitation
- [CHIPS-01](https://www.ietf.org/archive/id/draft-cutler-httpbis-partitioned-cookies-01.html)
  - `Partitioned` limitation

Hono is following the best practices.
The cookie helper will throw an `Error` when parsing cookies under the following conditions:

- The cookie name starts with `__Secure-`, but `secure` option is not set.
- The cookie name starts with `__Host-`, but `secure` option is not set.
- The cookie name starts with `__Host-`, but `path` is not `/`.
- The cookie name starts with `__Host-`, but `domain` is set.
- The `maxAge` option value is greater than 400 days.
- The `expires` option value is 400 days later than the current time.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import {
  deleteCookie,
  getCookie,
  getSignedCookie,
  setCookie,
  setSignedCookie,
  generateCookie,
  generateSignedCookie,
} from 'hono/cookie'
```

Example 2 (ts):
```ts
app.get('/cookie', (c) => {
  setCookie(c, 'cookie_name', 'cookie_value')
  const yummyCookie = getCookie(c, 'cookie_name')
  deleteCookie(c, 'cookie_name')
  const allCookies = getCookie(c)
  // ...
})
```

Example 3 (ts):
```ts
app.get('/signed-cookie', (c) => {
  const secret = 'secret' // make sure it's a large enough string to be secure

  await setSignedCookie(c, 'cookie_name0', 'cookie_value', secret)
  const fortuneCookie = await getSignedCookie(
    c,
    secret,
    'cookie_name0'
  )
  deleteCookie(c, 'cookie_name0')
  // `getSignedCookie` will return `false` for a specified cookie if the signature was tampered with or is invalid
  const allSignedCookies = await getSignedCookie(c, secret)
  // ...
})
```

Example 4 (ts):
```ts
// Basic cookie generation
const cookie = generateCookie('delicious_cookie', 'macha')
// Returns: 'delicious_cookie=macha; Path=/'

// Cookie with options
const cookie = generateCookie('delicious_cookie', 'macha', {
  path: '/',
  secure: true,
  httpOnly: true,
  domain: 'example.com',
})
```

---

## CORS Middleware

**URL:** llms-txt#cors-middleware

**Contents:**
- Import
- Usage
- Options
  - <Badge type="info" text="optional" /> origin: `string` | `string[]` | `(origin:string, c:Context) => string`
  - <Badge type="info" text="optional" /> allowMethods: `string[]` | `(origin:string, c:Context) => string[]`
  - <Badge type="info" text="optional" /> allowHeaders: `string[]`
  - <Badge type="info" text="optional" /> maxAge: `number`
  - <Badge type="info" text="optional" /> credentials: `boolean`
  - <Badge type="info" text="optional" /> exposeHeaders: `string[]`
- Environment-dependent CORS configuration

There are many use cases of Cloudflare Workers as Web APIs and calling them from external front-end application.
For them we have to implement CORS, let's do this with middleware as well.

Dynamic allowed methods based on origin:

### <Badge type="info" text="optional" /> origin: `string` | `string[]` | `(origin:string, c:Context) => string`

The value of "_Access-Control-Allow-Origin_" CORS header. You can also pass the callback function like `origin: (origin) => (origin.endsWith('.example.com') ? origin : 'http://example.com')`. The default is `*`.

### <Badge type="info" text="optional" /> allowMethods: `string[]` | `(origin:string, c:Context) => string[]`

The value of "_Access-Control-Allow-Methods_" CORS header. You can also pass a callback function to dynamically determine allowed methods based on the origin. The default is `['GET', 'HEAD', 'PUT', 'POST', 'DELETE', 'PATCH']`.

### <Badge type="info" text="optional" /> allowHeaders: `string[]`

The value of "_Access-Control-Allow-Headers_" CORS header. The default is `[]`.

### <Badge type="info" text="optional" /> maxAge: `number`

The value of "_Access-Control-Max-Age_" CORS header.

### <Badge type="info" text="optional" /> credentials: `boolean`

The value of "_Access-Control-Allow-Credentials_" CORS header.

### <Badge type="info" text="optional" /> exposeHeaders: `string[]`

The value of "_Access-Control-Expose-Headers_" CORS header. The default is `[]`.

## Environment-dependent CORS configuration

If you want to adjust CORS configuration according to the execution environment, such as development or production, injecting values from environment variables is convenient as it eliminates the need for the application to be aware of its own execution environment. See the example below for clarification.

When using Hono with Vite, you should disable Vite's built-in CORS feature by setting `server.cors` to `false` in your `vite.config.ts`. This prevents conflicts with Hono's CORS middleware.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { cors } from 'hono/cors'
```

Example 2 (ts):
```ts
const app = new Hono()

// CORS should be called before the route
app.use('/api/*', cors())
app.use(
  '/api2/*',
  cors({
    origin: 'http://example.com',
    allowHeaders: ['X-Custom-Header', 'Upgrade-Insecure-Requests'],
    allowMethods: ['POST', 'GET', 'OPTIONS'],
    exposeHeaders: ['Content-Length', 'X-Kuma-Revision'],
    maxAge: 600,
    credentials: true,
  })
)

app.all('/api/abc', (c) => {
  return c.json({ success: true })
})
app.all('/api2/abc', (c) => {
  return c.json({ success: true })
})
```

Example 3 (ts):
```ts
app.use(
  '/api3/*',
  cors({
    origin: ['https://example.com', 'https://example.org'],
  })
)

// Or you can use "function"
app.use(
  '/api4/*',
  cors({
    // `c` is a `Context` object
    origin: (origin, c) => {
      return origin.endsWith('.example.com')
        ? origin
        : 'http://example.com'
    },
  })
)
```

Example 4 (ts):
```ts
app.use(
  '/api5/*',
  cors({
    origin: (origin) =>
      origin === 'https://example.com' ? origin : '*',
    // `c` is a `Context` object
    allowMethods: (origin, c) =>
      origin === 'https://example.com'
        ? ['GET', 'HEAD', 'POST', 'PATCH', 'DELETE']
        : ['GET', 'HEAD'],
  })
)
```

---

## Create-hono

**URL:** llms-txt#create-hono

**Contents:**
- Passing arguments:

Command-line options supported by `create-hono` - the project initializer that runs when you run `npm create hono@latest`, `npx create-hono@latest`, or `pnpm create hono@latest`.

> [!NOTE]
> **Why this page?** The installation / quick-start examples often show a minimal `npm create hono@latest my-app` command. `create-hono` supports several useful flags you can pass to automate and customize project creation (select templates, skip prompts, pick a package manager, use local cache, and more).

## Passing arguments:

When you use `npm create` (or `npx`) arguments intended for the initializer script must be placed **after** `--`. Anything after `--` is forwarded to the initializer.

---

## CSRF Protection

**URL:** llms-txt#csrf-protection

**Contents:**
- Import
- Usage
- Options
  - <Badge type="info" text="optional" /> origin: `string` | `string[]` | `Function`
  - <Badge type="info" text="optional" /> secFetchSite: `string` | `string[]` | `Function`

This middleware protects against CSRF attacks by checking both the `Origin` header and the `Sec-Fetch-Site` header. The request is allowed if either validation passes.

The middleware only validates requests that:

- Use unsafe HTTP methods (not GET, HEAD, or OPTIONS)
- Have content types that can be sent by HTML forms (`application/x-www-form-urlencoded`, `multipart/form-data`, or `text/plain`)

Old browsers that do not send `Origin` headers, or environments that use reverse proxies to remove these headers, may not work well. In such environments, use other CSRF token methods.

### <Badge type="info" text="optional" /> origin: `string` | `string[]` | `Function`

Specify allowed origins for CSRF protection.

- **`string`**: Single allowed origin (e.g., `'https://example.com'`)
- **`string[]`**: Array of allowed origins
- **`Function`**: Custom handler `(origin: string, context: Context) => boolean` for flexible origin validation and bypass logic

**Default**: Only same origin as the request URL

The function handler receives the request's `Origin` header value and the request context, allowing for dynamic validation based on request properties like path, headers, or other context data.

### <Badge type="info" text="optional" /> secFetchSite: `string` | `string[]` | `Function`

Specify allowed Sec-Fetch-Site header values for CSRF protection using [Fetch Metadata](https://web.dev/articles/fetch-metadata).

- **`string`**: Single allowed value (e.g., `'same-origin'`)
- **`string[]`**: Array of allowed values (e.g., `['same-origin', 'none']`)
- **`Function`**: Custom handler `(secFetchSite: string, context: Context) => boolean` for flexible validation

**Default**: Only allows `'same-origin'`

Standard Sec-Fetch-Site values:

- `same-origin`: Request from same origin
- `same-site`: Request from same site (different subdomain)
- `cross-site`: Request from different site
- `none`: Request not from a web page (e.g., browser address bar, bookmark)

The function handler receives the request's `Sec-Fetch-Site` header value and the request context, enabling dynamic validation based on request properties.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { csrf } from 'hono/csrf'
```

Example 2 (ts):
```ts
const app = new Hono()

// Default: both origin and sec-fetch-site validation
app.use(csrf())

// Allow specific origins
app.use(csrf({ origin: 'https://myapp.example.com' }))

// Allow multiple origins
app.use(
  csrf({
    origin: [
      'https://myapp.example.com',
      'https://development.myapp.example.com',
    ],
  })
)

// Allow specific sec-fetch-site values
app.use(csrf({ secFetchSite: 'same-origin' }))
app.use(csrf({ secFetchSite: ['same-origin', 'none'] }))

// Dynamic origin validation
// It is strongly recommended that the protocol be verified to ensure a match to `$`.
// You should *never* do a forward match.
app.use(
  '*',
  csrf({
    origin: (origin) =>
      /https:\/\/(\w+\.)?myapp\.example\.com$/.test(origin),
  })
)

// Dynamic sec-fetch-site validation
app.use(
  csrf({
    secFetchSite: (secFetchSite, c) => {
      // Always allow same-origin
      if (secFetchSite === 'same-origin') return true
      // Allow cross-site for webhook endpoints
      if (
        secFetchSite === 'cross-site' &&
        c.req.path.startsWith('/webhook/')
      ) {
        return true
      }
      return false
    },
  })
)
```

---

## css Helper

**URL:** llms-txt#css-helper

**Contents:**
- Import
- `css` <Badge style="vertical-align: middle;" type="warning" text="Experimental" />
  - Extending
  - Global styles
- `keyframes` <Badge style="vertical-align: middle;" type="warning" text="Experimental" />
- `cx` <Badge style="vertical-align: middle;" type="warning" text="Experimental" />
- Usage in combination with [Secure Headers](/docs/middleware/builtin/secure-headers) middleware
- Tips

The css helper - `hono/css` - is Hono's built-in CSS in JS(X).

You can write CSS in JSX in a JavaScript template literal named `css`. The return value of `css` will be the class name, which is set to the value of the class attribute. The `<Style />` component will then contain the value of the CSS.

## `css` <Badge style="vertical-align: middle;" type="warning" text="Experimental" />

You can write CSS in the `css` template literal. In this case, it uses `headerClass` as a value of the `class` attribute. Don't forget to add `<Style />` as it contains the CSS content.

You can style pseudo-classes like `:hover` by using the [nesting selector](https://developer.mozilla.org/en-US/docs/Web/CSS/Nesting_selector), `&`:

You can extend the CSS definition by embedding the class name.

In addition, the syntax of `${baseClass} {}` enables nesting classes.

A pseudo-selector called `:-hono-global` allows you to define global styles.

Or you can write CSS in the `<Style />` component with the `css` literal.

## `keyframes` <Badge style="vertical-align: middle;" type="warning" text="Experimental" />

You can use `keyframes` to write the contents of `@keyframes`. In this case, `fadeInAnimation` will be the name of the animation

## `cx` <Badge style="vertical-align: middle;" type="warning" text="Experimental" />

The `cx` composites the two class names.

It can also compose simple strings.

## Usage in combination with [Secure Headers](/docs/middleware/builtin/secure-headers) middleware

If you want to use the css helpers in combination with the [Secure Headers](/docs/middleware/builtin/secure-headers) middleware, you can add the [`nonce` attribute](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/nonce) to the `<Style nonce={c.get('secureHeadersNonce')} />` to avoid Content-Security-Policy caused by the css helpers.

If you use VS Code, you can use [vscode-styled-components](https://marketplace.visualstudio.com/items?itemName=styled-components.vscode-styled-components) for Syntax highlighting and IntelliSense for css tagged literals.

![](/images/css-ss.png)

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { css, cx, keyframes, Style } from 'hono/css'
```

Example 2 (unknown):
```unknown
You can style pseudo-classes like `:hover` by using the [nesting selector](https://developer.mozilla.org/en-US/docs/Web/CSS/Nesting_selector), `&`:
```

Example 3 (unknown):
```unknown
### Extending

You can extend the CSS definition by embedding the class name.
```

Example 4 (unknown):
```unknown
In addition, the syntax of `${baseClass} {}` enables nesting classes.
```

---

## Deno

**URL:** llms-txt#deno

**Contents:**
- 1. Install Deno
- 2. Setup
- 3. Hello World
- 4. Run
- Change port number
- Serve static files
  - `rewriteRequestPath`
  - `mimes`
  - `onFound`
  - `onNotFound`

[Deno](https://deno.com/) is a JavaScript runtime built on V8. It's not Node.js.
Hono also works on Deno.

You can use Hono, write the code with TypeScript, run the application with the `deno` command, and deploy it to "Deno Deploy".

First, install `deno` command.
Please refer to [the official document](https://docs.deno.com/runtime/getting_started/installation/).

A starter for Deno is available.
Start your project with the [`deno init`](https://docs.deno.com/runtime/reference/cli/init/) command.

Move into `my-app`. For Deno, you don't have to install Hono explicitly.

Run the development server locally. Then, access `http://localhost:8000` in your Web browser.

## Change port number

You can specify the port number by updating the arguments of `Deno.serve` in `main.ts`:

## Serve static files

To serve static files, use `serveStatic` imported from `hono/deno`.

For the above code, it will work well with the following directory structure.

### `rewriteRequestPath`

If you want to map `http://localhost:8000/static/*` to `./statics`, you can use the `rewriteRequestPath` option:

You can add MIME types with `mimes`:

You can specify handling when the requested file is found with `onFound`:

You can specify handling when the requested file is not found with `onNotFound`:

The `precompressed` option checks if files with extensions like `.br` or `.gz` are available and serves them based on the `Accept-Encoding` header. It prioritizes Brotli, then Zstd, and Gzip. If none are available, it serves the original file.

Deno Deploy is a serverless platform for running JavaScript and TypeScript applications in the cloud.
It provides a management plane for deploying and running applications through integrations like GitHub deployment.

Hono also works on Deno Deploy. Please refer to [the official document](https://docs.deno.com/deploy/manual/).

Testing the application on Deno is easy.
You can write with `Deno.test` and use `assert` or `assertEquals` from [@std/assert](https://jsr.io/@std/assert).

Then run the command:

Hono is available on both [npm](https://www.npmjs.com/package/hono) and [JSR](https://jsr.io/@hono/hono) (the JavaScript Registry). You can use either `npm:hono` or `jsr:@hono/hono` in your `deno.json`:

When using third-party middleware, you may need to use Hono from the same registry as the middleware for proper TypeScript type inference. For example, if using the middleware from npm, you should also use Hono from npm:

We also provide many third-party middleware packages on [JSR](https://jsr.io/@hono). When using the middleware on JSR, use Hono from JSR:

**Examples:**

Example 1 (sh):
```sh
deno init --npm hono --template=deno my-app
```

Example 2 (sh):
```sh
cd my-app
```

Example 3 (unknown):
```unknown
## 4. Run

Run the development server locally. Then, access `http://localhost:8000` in your Web browser.
```

Example 4 (unknown):
```unknown
## Change port number

You can specify the port number by updating the arguments of `Deno.serve` in `main.ts`:
```

---

## Developer Experience

**URL:** llms-txt#developer-experience

To create a great application, we need great development experience.
Fortunately, we can write applications for Cloudflare Workers, Deno, and Bun in TypeScript without having the need to transpile it to JavaScript.
Hono is written in TypeScript and can make applications type-safe.

---

## Dev Helper

**URL:** llms-txt#dev-helper

**Contents:**
- `getRouterName()`
- `showRoutes()`
- Options
  - <Badge type="info" text="optional" /> verbose: `boolean`
  - <Badge type="info" text="optional" /> colorize: `boolean`

Dev Helper provides useful methods you can use in development.

You can get the name of the currently used router with `getRouterName()`.

`showRoutes()` function displays the registered routes in your console.

Consider an application like the following:

When this application starts running, the routes will be shown in your console as follows:

### <Badge type="info" text="optional" /> verbose: `boolean`

When set to `true`, it displays verbose information.

### <Badge type="info" text="optional" /> colorize: `boolean`

When set to `false`, the output will not be colored.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { getRouterName, showRoutes } from 'hono/dev'
```

Example 2 (ts):
```ts
const app = new Hono()

// ...

console.log(getRouterName(app))
```

Example 3 (ts):
```ts
const app = new Hono().basePath('/v1')

app.get('/posts', (c) => {
  // ...
})

app.get('/posts/:id', (c) => {
  // ...
})

app.post('/posts', (c) => {
  // ...
})

showRoutes(app, {
  verbose: true,
})
```

Example 4 (txt):
```txt
GET   /v1/posts
GET   /v1/posts/:id
POST  /v1/posts
```

---

## ETag Middleware

**URL:** llms-txt#etag-middleware

**Contents:**
- Import
- Usage
- The retained headers
- Options
  - <Badge type="info" text="optional" /> weak: `boolean`
  - <Badge type="info" text="optional" /> retainedHeaders: `string[]`
  - <Badge type="info" text="optional" /> generateDigest: `(body: Uint8Array) => ArrayBuffer | Promise<ArrayBuffer>`

Using this middleware, you can add ETag headers easily.

## The retained headers

The 304 Response must include the headers that would have been sent in an equivalent 200 OK response. The default headers are Cache-Control, Content-Location, Date, ETag, Expires, and Vary.

If you want to add the header that is sent, you can use `retainedHeaders` option and `RETAINED_304_HEADERS` strings array variable that includes the default headers:

### <Badge type="info" text="optional" /> weak: `boolean`

Define using or not using a [weak validation](https://developer.mozilla.org/en-US/docs/Web/HTTP/Conditional_requests#weak_validation). If `true` is set, then `w/` is added to the prefix of the value. The default is `false`.

### <Badge type="info" text="optional" /> retainedHeaders: `string[]`

The headers that you want to retain in the 304 Response.

### <Badge type="info" text="optional" /> generateDigest: `(body: Uint8Array) => ArrayBuffer | Promise<ArrayBuffer>`

A custom digest generation function. By default, it uses `SHA-1`. This function is called with the response body as a `Uint8Array` and should return a hash as an `ArrayBuffer` or a Promise of one.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { etag } from 'hono/etag'
```

Example 2 (ts):
```ts
const app = new Hono()

app.use('/etag/*', etag())
app.get('/etag/abc', (c) => {
  return c.text('Hono is cool')
})
```

Example 3 (ts):
```ts
import { etag, RETAINED_304_HEADERS } from 'hono/etag'

// ...

app.use(
  '/etag/*',
  etag({
    retainedHeaders: ['x-message', ...RETAINED_304_HEADERS],
  })
)
```

---

## Examples

**URL:** llms-txt#examples

See the [Examples section](/examples/).

---

## Factory Helper

**URL:** llms-txt#factory-helper

**Contents:**
- Import
- `createFactory()`
  - Options
  - <Badge type="info" text="optional" /> defaultAppOptions: `HonoOptions`
- `createMiddleware()`
- `factory.createHandlers()`
- `factory.createApp()`

The Factory Helper provides useful functions for creating Hono's components such as Middleware. Sometimes it's difficult to set the proper TypeScript types, but this helper facilitates that.

`createFactory()` will create an instance of the Factory class.

You can pass your Env types as Generics:

### <Badge type="info" text="optional" /> defaultAppOptions: `HonoOptions`

The default options to pass to the Hono application created by `createApp()`.

## `createMiddleware()`

`createMiddleware()` is shortcut of `factory.createMiddleware()`.
This function will create your custom middleware.

Tip: If you want to get an argument like `message`, you can create it as a function like the following.

## `factory.createHandlers()`

`createHandlers()` helps to define handlers in a different place than `app.get('/')`.

## `factory.createApp()`

`createApp()` helps to create an instance of Hono with the proper types. If you use this method with `createFactory()`, you can avoid redundancy in the definition of the `Env` type.

If your application is like this, you have to set the `Env` in two places:

By using `createFactory()` and `createApp()`, you can set the `Env` only in one place.

`createFactory()` can receive the `initApp` option to initialize an `app` created by `createApp()`. The following is an example that uses the option.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { createFactory, createMiddleware } from 'hono/factory'
```

Example 2 (ts):
```ts
import { createFactory } from 'hono/factory'

const factory = createFactory()
```

Example 3 (ts):
```ts
type Env = {
  Variables: {
    foo: string
  }
}

const factory = createFactory<Env>()
```

Example 4 (ts):
```ts
const factory = createFactory({
  defaultAppOptions: { strict: false },
})

const app = factory.createApp() // `strict: false` is applied
```

---

## Fastly Compute

**URL:** llms-txt#fastly-compute

**Contents:**
- 1. Setup
- 2. Hello World
- 3. Run
- 4. Deploy
- Bindings

[Fastly Compute](https://www.fastly.com/products/edge-compute) is an advanced edge computing system that runs your code, in your favorite language, on Fastly's global edge network. Hono also works on Fastly Compute.

You can develop the application locally and publish it with a few commands using [Fastly CLI](https://www.fastly.com/documentation/reference/tools/cli/), which is installed locally automatically as part of the template.

A starter for Fastly Compute is available.
Start your project with "create-hono" command.
Select `fastly` template for this example.

Move to `my-app` and install the dependencies.

> [!NOTE]
> When using `fire` (or `buildFire()`) from `@fastly/hono-fastly-compute'` at the top level of your application, it is suitable to use `Hono` from `'hono'` rather than `'hono/quick'`, because `fire` causes its router to build its internal data during the application initialization phase.

Run the development server locally. Then, access `http://localhost:7676` in your Web browser.

To build and deploy your application to your Fastly account, type the following command. The first time you deploy the application, you will be prompted to create a new service in your account.

If you don't have an account yet, you must [create your Fastly account](https://www.fastly.com/signup/).

In Fastly Compute, you can bind Fastly platform resources, such as KV Stores, Config Stores, Secret Stores, Backends, Access Control Lists, Named Log Streams, and Environment Variables. You can access them through `c.env`, and will have their individual SDK types.

To use these bindings, import `buildFire` instead of `fire` from `@fastly/hono-fastly-compute`. Define your [bindings](https://github.com/fastly/compute-js-context?tab=readme-ov-file#typed-bindings-with-buildcontextproxy) and pass them to [`buildFire()`](https://github.com/fastly/hono-fastly-compute?tab=readme-ov-file#basic-example) to obtain `fire`. Then use `fire.Bindings` to define your `Env` type as you construct `Hono`.

**Examples:**

Example 1 (unknown):
```unknown

```

Example 2 (unknown):
```unknown

```

Example 3 (unknown):
```unknown

```

Example 4 (unknown):
```unknown

```

---

## Forwarding arguments to create-hono (npm requires `--`)

**URL:** llms-txt#forwarding-arguments-to-create-hono-(npm-requires-`--`)

npm create hono@latest my-app -- --template cloudflare-workers
sh [yarn]

**Examples:**

Example 1 (unknown):
```unknown

```

---

## Frequently Asked Questions

**URL:** llms-txt#frequently-asked-questions

**Contents:**
- Is there an official Renovate config for Hono?

This guide is a collection of frequently asked questions (FAQ) about Hono and how to resolve them.

## Is there an official Renovate config for Hono?

The Hono teams does not currently maintain [Renovate](https://github.com/renovatebot/renovate) Configuration.
Therefore, please use third-party renovate-config as follows.

In your `renovate.json` :

see [renovate-config-hono](https://github.com/shinGangan/renovate-config-hono) repository for more details.

**Examples:**

Example 1 (json):
```json
// renovate.json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": [
    "github>shinGangan/renovate-config-hono" // [!code ++]
  ]
}
```

---

## Getting Started

**URL:** llms-txt#getting-started

**Contents:**
- Starter
- Hello World
- Return JSON
- Request and Response
- Return HTML
- Return raw Response
- Using Middleware
- Adapter
- Next step

Using Hono is super easy. We can set up the project, write code, develop with a local server, and deploy quickly. The same code will work on any runtime, just with different entry points. Let's look at the basic usage of Hono.

Starter templates are available for each platform. Use the following "create-hono" command.

Then you will be asked which template you would like to use.
Let's select Cloudflare Workers for this example.

The template will be pulled into `my-app`, so go to it and install the dependencies.

Once the package installation is complete, run the following command to start up a local server.

You can write code in TypeScript with the Cloudflare Workers development tool "Wrangler", Deno, Bun, or others without being aware of transpiling.

Write your first application with Hono in `src/index.ts`. The example below is a starter Hono application.

The `import` and the final `export default` parts may vary from runtime to runtime,
but all of the application code will run the same code everywhere.

Start the development server and access `http://localhost:8787` with your browser.

Returning JSON is also easy. The following is an example of handling a GET Request to `/api/hello` and returning an `application/json` Response.

## Request and Response

Getting a path parameter, URL query value, and appending a Response header is written as follows.

We can easily handle POST, PUT, and DELETE not only GET.

You can write HTML with [the html Helper](/docs/helpers/html) or using [JSX](/docs/guides/jsx) syntax. If you want to use JSX, rename the file to `src/index.tsx` and configure it (check with each runtime as it is different). Below is an example using JSX.

## Return raw Response

You can also return the raw [Response](https://developer.mozilla.org/en-US/docs/Web/API/Response).

Middleware can do the hard work for you.
For example, add in Basic Authentication.

There are useful built-in middleware including Bearer and authentication using JWT, CORS and ETag.
Hono also provides third-party middleware using external libraries such as GraphQL Server and Firebase Auth.
And, you can make your own middleware.

There are Adapters for platform-dependent functions, e.g., handling static files or WebSocket.
For example, to handle WebSocket in Cloudflare Workers, import `hono/cloudflare-workers`.

Most code will work on any platform, but there are guides for each.
For instance, how to set up projects or how to deploy.
Please see the page for the exact platform you want to use to create your application!

**Examples:**

Example 1 (unknown):
```unknown

```

Example 2 (unknown):
```unknown

```

Example 3 (unknown):
```unknown

```

Example 4 (unknown):
```unknown

```

---

## Google Cloud Run

**URL:** llms-txt#google-cloud-run

**Contents:**
- 1. Install the CLI
- 2. Project setup
- 3. Hello World
- 4. Deploy
- Changing runtimes

[Google Cloud Run](https://cloud.google.com/run) is a serverless platform built by Google Cloud. You can run your code in response to events and Google automatically manages the underlying compute resources for you.

Google Cloud Run uses containers to run your service. This means you can use any runtime you like (E.g., Deno or Bun) by providing a Dockerfile. If no Dockerfile is provided Google Cloud Run will use the default Nodejs buildpack.

This guide assumes you already have a Google Cloud account and a billing account.

## 1. Install the CLI

When working with Google Cloud Platform it is easiest to work with the [gcloud CLI](https://cloud.google.com/sdk/docs/install).

For example, on MacOS using Homebrew:

Authenticate with the CLI.

Create a project. Accept the auto-generated project ID at the prompt.

Create environment variables for your project ID and project number for easy reuse. It may take ~30 seconds before the project successfully returns with the `gcloud projects list` command.

Find your billing account ID.

Add your billing account from the prior command to the project.

Enable the required APIs.

Update the service account permissions to have access to Cloud Build.

Start your project with "create-hono" command. Select `nodejs`.

Move to `my-app` and install the dependencies.

Update the port in `src/index.ts` to be `8080`.

<!-- prettier-ignore -->

Run the development server locally. Then, access http://localhost:8080 in your Web browser.

Start the deployment and follow the interactive prompts (E.g., select a region).

If you want to deploy using Deno or Bun runtimes (or a customised Nodejs container), add a `Dockerfile` (and optionally `.dockerignore`) with your desired environment.

For information on containerizing please refer to:

- [Nodejs](/docs/getting-started/nodejs#building-deployment)
- [Bun](https://bun.com/guides/ecosystem/docker)
- [Deno](https://docs.deno.com/examples/google_cloud_run_tutorial)

**Examples:**

Example 1 (sh):
```sh
brew install --cask google-cloud-sdk
```

Example 2 (sh):
```sh
gcloud auth login
```

Example 3 (sh):
```sh
gcloud projects create --set-as-default --name="my app"
```

Example 4 (sh):
```sh
PROJECT_ID=$(gcloud projects list \
    --format='value(projectId)' \
    --filter='name="my app"')

PROJECT_NUMBER=$(gcloud projects list \
    --format='value(projectNumber)' \
    --filter='name="my app"')

echo $PROJECT_ID $PROJECT_NUMBER
```

---

## Helpers

**URL:** llms-txt#helpers

**Contents:**
- Available Helpers

Helpers are available to assist in developing your application. Unlike middleware, they don't act as handlers, but rather provide useful functions.

For instance, here's how to use the [Cookie helper](/docs/helpers/cookie):

- [Accepts](/docs/helpers/accepts)
- [Adapter](/docs/helpers/adapter)
- [Cookie](/docs/helpers/cookie)
- [css](/docs/helpers/css)
- [Dev](/docs/helpers/dev)
- [Factory](/docs/helpers/factory)
- [html](/docs/helpers/html)
- [JWT](/docs/helpers/jwt)
- [SSG](/docs/helpers/ssg)
- [Streaming](/docs/helpers/streaming)
- [Testing](/docs/helpers/testing)
- [WebSocket](/docs/helpers/websocket)

**Examples:**

Example 1 (ts):
```ts
import { getCookie, setCookie } from 'hono/cookie'

const app = new Hono()

app.get('/cookie', (c) => {
  const yummyCookie = getCookie(c, 'yummy_cookie')
  // ...
  setCookie(c, 'delicious_cookie', 'macha')
  //
})
```

---

## HonoRequest

**URL:** llms-txt#honorequest

**Contents:**
- param()
- query()
- queries()
- header()
- parseBody()
  - Multiple files
  - Multiple files or fields with same name
  - Dot notation
- json()
- text()

The `HonoRequest` is an object that can be taken from `c.req` which wraps a [Request](https://developer.mozilla.org/en-US/docs/Web/API/Request) object.

Get the values of path parameters.

Get querystring parameters.

Get multiple querystring parameter values, e.g. `/search?tags=A&tags=B`

Get the request header value.

::: warning
When `c.req.header()` is called with no arguments, all keys in the returned record are **lowercase**.

If you want to get the value of a header with an uppercase name,
use `c.req.header(“X-Foo”)`.

Parse Request body of type `multipart/form-data` or `application/x-www-form-urlencoded`

`parseBody()` supports the following behaviors.

`body['foo']` is `(string | File)`.

If multiple files are uploaded, the last one will be used.

`body['foo[]']` is always `(string | File)[]`.

`[]` postfix is required.

### Multiple files or fields with same name

If you have a input field that allows multiple `<input type="file" multiple />` or multiple checkboxes with the same name `<input type="checkbox" name="favorites" value="Hono"/>`.

`all` option is disabled by default.

- If `body['foo']` is multiple files, it will be parsed to `(string | File)[]`.
- If `body['foo']` is single file, it will be parsed to `(string | File)`.

If you set the `dot` option `true`, the return value is structured based on the dot notation.

Imagine receiving the following data:

You can get the structured value by setting the `dot` option `true`:

Parses the request body of type `application/json`

Parses the request body of type `text/plain`

Parses the request body as an `ArrayBuffer`

Parses the request body as a `Blob`.

Parses the request body as a `FormData`.

Get the validated data.

Available targets are below.

- `form`
- `json`
- `query`
- `header`
- `cookie`
- `param`

See the [Validation section](/docs/guides/validation) for usage examples.

::: warning
**Deprecated in v4.8.0**: This property is deprecated. Use `routePath()` from [Route Helper](/docs/helpers/route) instead.
:::

You can retrieve the registered path within the handler like this:

If you access `/posts/123`, it will return `/posts/:id`:

::: warning
**Deprecated in v4.8.0**: This property is deprecated. Use `matchedRoutes()` from [Route Helper](/docs/helpers/route) instead.
:::

It returns matched routes within the handler, which is useful for debugging.

The request pathname.

The request url strings.

The method name of the request.

The raw [`Request`](https://developer.mozilla.org/en-US/docs/Web/API/Request) object.

Clones the raw Request object from a HonoRequest. Works even after the request body has been consumed by validators or HonoRequest methods.

**Examples:**

Example 1 (unknown):
```unknown
## query()

Get querystring parameters.
```

Example 2 (unknown):
```unknown
## queries()

Get multiple querystring parameter values, e.g. `/search?tags=A&tags=B`
```

Example 3 (unknown):
```unknown
## header()

Get the request header value.
```

Example 4 (unknown):
```unknown
::: warning
When `c.req.header()` is called with no arguments, all keys in the returned record are **lowercase**.

If you want to get the value of a header with an uppercase name,
use `c.req.header(“X-Foo”)`.
```

---

## Hono

**URL:** llms-txt#hono

**Contents:**
- Quick Start
- Features
- Use-cases
- Who is using Hono?
- Hono in 1 minute
- Ultrafast
- Lightweight
- Multiple routers
- Web Standards
- Middleware & Helpers

Hono - _**means flame🔥 in Japanese**_ - is a small, simple, and ultrafast web framework built on Web Standards.
It works on any JavaScript runtime: Cloudflare Workers, Fastly Compute, Deno, Bun, Vercel, Netlify, AWS Lambda, Lambda@Edge, and Node.js.

Fast, but not only fast.

- **Ultrafast** 🚀 - The router `RegExpRouter` is really fast. Not using linear loops. Fast.
- **Lightweight** 🪶 - The `hono/tiny` preset is under 14kB. Hono has zero dependencies and uses only the Web Standards.
- **Multi-runtime** 🌍 - Works on Cloudflare Workers, Fastly Compute, Deno, Bun, AWS Lambda, or Node.js. The same code runs on all platforms.
- **Batteries Included** 🔋 - Hono has built-in middleware, custom middleware, third-party middleware, and helpers. Batteries included.
- **Delightful DX** 😃 - Super clean APIs. First-class TypeScript support. Now, we've got "Types".

Hono is a simple web application framework similar to Express, without a frontend.
But it runs on CDN Edges and allows you to construct larger applications when combined with middleware.
Here are some examples of use-cases.

- Building Web APIs
- Proxy of backend servers
- Front of CDN
- Edge application
- Base server for a library
- Full-stack application

## Who is using Hono?

| Project                                                                            | Platform           | What for?                                                                                                   |
| ---------------------------------------------------------------------------------- | ------------------ | ----------------------------------------------------------------------------------------------------------- |
| [cdnjs](https://cdnjs.com)                                                         | Cloudflare Workers | A free and open-source CDN service. _Hono is used for the API server_.                                      |
| [Cloudflare D1](https://www.cloudflare.com/developer-platform/d1/)                 | Cloudflare Workers | Serverless SQL databases. _Hono is used for the internal API server_.                                       |
| [Cloudflare Workers KV](https://www.cloudflare.com/developer-platform/workers-kv/) | Cloudflare Workers | Serverless key-value database. _Hono is used for the internal API server_.                                  |
| [BaseAI](https://baseai.dev)                                                       | Local AI Server    | Serverless AI agent pipes with memory. An open-source agentic AI framework for web. _API server with Hono_. |
| [Unkey](https://unkey.dev)                                                         | Cloudflare Workers | An open-source API authentication and authorization. _Hono is used for the API server_.                     |
| [OpenStatus](https://openstatus.dev)                                               | Bun                | An open-source website & API monitoring platform. _Hono is used for the API server_.                        |
| [Deno Benchmarks](https://deno.com/benchmarks)                                     | Deno               | A secure TypeScript runtime built on V8. _Hono is used for benchmarking_.                                   |
| [Clerk](https://clerk.com)                                                         | Cloudflare Workers | An open-source User Management Platform. _Hono is used for the API server_.                                 |

- [Drivly](https://driv.ly/) - Cloudflare Workers
- [repeat.dev](https://repeat.dev/) - Cloudflare Workers

Do you want to see more? See [Who is using Hono in production?](https://github.com/orgs/honojs/discussions/1510).

A demonstration to create an application for Cloudflare Workers with Hono.

![A gif showing a hono app being created quickly with fast iteration.](/images/sc.gif)

**Hono is the fastest**, compared to other routers for Cloudflare Workers.

See [more benchmarks](/docs/concepts/benchmarks).

**Hono is so small**. With the `hono/tiny` preset, its size is **under 14KB** when minified. There are many middleware and adapters, but they are bundled only when used. For context, the size of Express is 572KB.

**Hono has multiple routers**.

**RegExpRouter** is the fastest router in the JavaScript world. It matches the route using a single large Regex created before dispatch. With **SmartRouter**, it supports all route patterns.

**LinearRouter** registers the routes very quickly, so it's suitable for an environment that initializes applications every time. **PatternRouter** simply adds and matches the pattern, making it small.

See [more information about routes](/docs/concepts/routers).

Thanks to the use of the **Web Standards**, Hono works on a lot of platforms.

- Cloudflare Workers
- Cloudflare Pages
- Fastly Compute
- Deno
- Bun
- Vercel
- AWS Lambda
- Lambda@Edge
- Others

And by using [a Node.js adapter](https://github.com/honojs/node-server), Hono works on Node.js.

See [more information about Web Standards](/docs/concepts/web-standard).

## Middleware & Helpers

**Hono has many middleware and helpers**. This makes "Write Less, do more" a reality.

Out of the box, Hono provides middleware and helpers for:

- [Basic Authentication](/docs/middleware/builtin/basic-auth)
- [Bearer Authentication](/docs/middleware/builtin/bearer-auth)
- [Body Limit](/docs/middleware/builtin/body-limit)
- [Cache](/docs/middleware/builtin/cache)
- [Compress](/docs/middleware/builtin/compress)
- [Context Storage](/docs/middleware/builtin/context-storage)
- [Cookie](/docs/helpers/cookie)
- [CORS](/docs/middleware/builtin/cors)
- [ETag](/docs/middleware/builtin/etag)
- [html](/docs/helpers/html)
- [JSX](/docs/guides/jsx)
- [JWT Authentication](/docs/middleware/builtin/jwt)
- [Logger](/docs/middleware/builtin/logger)
- [Language](/docs/middleware/builtin/language)
- [Pretty JSON](/docs/middleware/builtin/pretty-json)
- [Secure Headers](/docs/middleware/builtin/secure-headers)
- [SSG](/docs/helpers/ssg)
- [Streaming](/docs/helpers/streaming)
- [GraphQL Server](https://github.com/honojs/middleware/tree/main/packages/graphql-server)
- [Firebase Authentication](https://github.com/honojs/middleware/tree/main/packages/firebase-auth)
- [Sentry](https://github.com/honojs/middleware/tree/main/packages/sentry)
- Others!

For example, adding ETag and request logging only takes a few lines of code with Hono:

See [more information about Middleware](/docs/concepts/middleware).

## Developer Experience

Hono provides a delightful "**Developer Experience**".

Easy access to Request/Response thanks to the `Context` object.
Moreover, Hono is written in TypeScript. Hono has "**Types**".

For example, the path parameters will be literal types.

![A screenshot showing Hono having proper literal typing when URL parameters. The URL "/entry/:date/:id" allows for request parameters to be "date" or "id"](/images/ss.png)

And, the Validator and Hono Client `hc` enable the RPC mode. In RPC mode,
you can use your favorite validator such as Zod and easily share server-side API specs with the client and build type-safe applications.

See [Hono Stacks](/docs/concepts/stacks).

**Examples:**

Example 1 (unknown):
```unknown
## Quick Start

Just run this:

::: code-group
```

Example 2 (unknown):
```unknown

```

Example 3 (unknown):
```unknown

```

Example 4 (unknown):
```unknown

```

---

## Hono Stacks

**URL:** llms-txt#hono-stacks

**Contents:**
- RPC
- Writing API
- Validation with Zod
- Sharing the Types
- Client
- With React

Hono makes easy things easy and hard things easy.
It is suitable for not just only returning JSON.
But it's also great for building the full-stack application including REST API servers and the client.

Hono's RPC feature allows you to share API specs with little change to your code.
The client generated by `hc` will read the spec and access the endpoint type-safety.

The following libraries make it possible.

- Hono - API Server
- [Zod](https://zod.dev) - Validator
- [Zod Validator Middleware](https://github.com/honojs/middleware/tree/main/packages/zod-validator)
- `hc` - HTTP Client

We can call the set of these components the **Hono Stack**.
Now let's create an API server and a client with it.

First, write an endpoint that receives a GET request and returns JSON.

## Validation with Zod

Validate with Zod to receive the value of the query parameter.

![](/images/sc01.gif)

To emit an endpoint specification, export its type.

For the RPC to infer routes correctly, all included methods must be chained, and the endpoint or app type must be inferred from a declared variable. For more, see [Best Practices for RPC](https://hono.dev/docs/guides/best-practices#if-you-want-to-use-rpc-features).

Next. The client-side implementation.
Create a client object by passing the `AppType` type to `hc` as generics.
Then, magically, completion works and the endpoint path and request type are suggested.

![](/images/sc03.gif)

The `Response` is compatible with the fetch API, but the data that can be retrieved with `json()` has a type.

![](/images/sc04.gif)

Sharing API specifications means that you can be aware of server-side changes.

![](/images/ss03.png)

You can create applications on Cloudflare Pages using React.

The client with React and React Query.

**Examples:**

Example 1 (unknown):
```unknown
## Validation with Zod

Validate with Zod to receive the value of the query parameter.

![](/images/sc01.gif)
```

Example 2 (unknown):
```unknown
## Sharing the Types

To emit an endpoint specification, export its type.

::: warning

For the RPC to infer routes correctly, all included methods must be chained, and the endpoint or app type must be inferred from a declared variable. For more, see [Best Practices for RPC](https://hono.dev/docs/guides/best-practices#if-you-want-to-use-rpc-features).

:::
```

Example 3 (unknown):
```unknown
## Client

Next. The client-side implementation.
Create a client object by passing the `AppType` type to `hc` as generics.
Then, magically, completion works and the endpoint path and request type are suggested.

![](/images/sc03.gif)
```

Example 4 (unknown):
```unknown
The `Response` is compatible with the fetch API, but the data that can be retrieved with `json()` has a type.

![](/images/sc04.gif)
```

---

## html Helper

**URL:** llms-txt#html-helper

**Contents:**
- Import
- `html`
  - Insert snippets into JSX
  - Act as functional component
  - Receives props and embeds values
- `raw()`
- Tips

The html Helper lets you write HTML in JavaScript template literal with a tag named `html`. Using `raw()`, the content will be rendered as is. You have to escape these strings by yourself.

### Insert snippets into JSX

Insert the inline script into JSX:

### Act as functional component

Since `html` returns an HtmlEscapedString, it can act as a fully functional component without using JSX.

#### Use `html` to speed up the process instead of `memo`

### Receives props and embeds values

Thanks to these libraries, Visual Studio Code and vim also interprets template literals as HTML, allowing syntax highlighting and formatting to be applied.

- <https://marketplace.visualstudio.com/items?itemName=bierner.lit-html>
- <https://github.com/MaxMEllon/vim-jsx-pretty>

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { html, raw } from 'hono/html'
```

Example 2 (ts):
```ts
const app = new Hono()

app.get('/:username', (c) => {
  const { username } = c.req.param()
  return c.html(
    html`<!doctype html>
      <h1>Hello! ${username}!</h1>`
  )
})
```

Example 3 (tsx):
```tsx
app.get('/', (c) => {
  return c.html(
    <html>
      <head>
        <title>Test Site</title>
        {html`
          <script>
            // No need to use dangerouslySetInnerHTML.
            // If you write it here, it will not be escaped.
          </script>
        `}
      </head>
      <body>Hello!</body>
    </html>
  )
})
```

Example 4 (typescript):
```typescript
const Footer = () => html`
  <footer>
    <address>My Address...</address>
  </footer>
`
```

---

## HTTPException

**URL:** llms-txt#httpexception

**Contents:**
- Throwing HTTPExceptions
  - Custom Message
  - Custom Response
  - Cause
- Handling HTTPExceptions

When a fatal error occurs, Hono (and many ecosystem middleware) may throw an `HTTPException`. This is a custom Hono `Error` that simplifies [returning error responses](#handling-httpexceptions).

## Throwing HTTPExceptions

You can throw your own HTTPExceptions by specifying a status code, and either a message or a custom response.

For basic `text` responses, just set a the error `message`.

For other response types, or to set response headers, use the `res` option. _Note that the status passed to the constructor is the one used to create responses._

In either case, you can use the [`cause`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error/cause) option to add arbitrary data to the HTTPException.

## Handling HTTPExceptions

You can handle uncaught HTTPExceptions with [`app.onError`](/docs/api/hono#error-handling). They include a `getResponse` method that returns a new `Response` created from the error `status`, and either the error `message`, or the [custom response](#custom-response) set when the error was thrown.

::: warning
**`HTTPException.getResponse` is not aware of `Context`**. To include headers already set in `Context`, you must apply them to a new `Response`.
:::

**Examples:**

Example 1 (unknown):
```unknown
### Custom Response

For other response types, or to set response headers, use the `res` option. _Note that the status passed to the constructor is the one used to create responses._
```

Example 2 (unknown):
```unknown
### Cause

In either case, you can use the [`cause`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error/cause) option to add arbitrary data to the HTTPException.
```

Example 3 (unknown):
```unknown
## Handling HTTPExceptions

You can handle uncaught HTTPExceptions with [`app.onError`](/docs/api/hono#error-handling). They include a `getResponse` method that returns a new `Response` created from the error `status`, and either the error `message`, or the [custom response](#custom-response) set when the error was thrown.
```

---

## Input your AccessKeyID & AccessKeySecret

**URL:** llms-txt#input-your-accesskeyid-&-accesskeysecret

**Contents:**
- 4. Deploy

yaml
edition: 3.0.0
name: my-app
access: 'default'

vars:
  region: 'us-west-1'

resources:
  my-app:
    component: fc3
    props:
      region: ${vars.region}
      functionName: 'my-app'
      description: 'Hello World by Hono'
      runtime: 'nodejs20'
      code: ./dist
      handler: index.handler
      memorySize: 1024
      timeout: 300
json
{
  "scripts": {
    "build": "esbuild --bundle --outfile=./dist/index.js --platform=node --target=node20 ./src/index.ts",
    "deploy": "s deploy -y"
  }
}
sh
npm run build # Compile the TypeScript code to JavaScript
npm run deploy # Deploy the function to Alibaba Cloud Function Compute
```

**Examples:**

Example 1 (unknown):
```unknown
Edit `s.yaml`
```

Example 2 (unknown):
```unknown
Edit `scripts` section in `package.json`:
```

Example 3 (unknown):
```unknown
## 4. Deploy

Finally, run the command to deploy:
```

---

## IP Restriction Middleware

**URL:** llms-txt#ip-restriction-middleware

**Contents:**
- Import
- Usage
- Rules
  - IPv4
  - IPv6
- Error handling

IP Restriction Middleware is middleware that limits access to resources based on the IP address of the user.

For your application running on Bun, if you want to allow access only from local, you can write it as follows. Specify the rules you want to deny in the `denyList` and the rules you want to allow in the `allowList`.

Pass the `getConninfo` from the [ConnInfo helper](/docs/helpers/conninfo) appropriate for your environment as the first argument of `ipRestriction`. For example, for Deno, it would look like this:

Follow the instructions below for writing rules.

- `192.168.2.0` - Static IP Address
- `192.168.2.0/24` - CIDR Notation
- `*` - ALL Addresses

- `::1` - Static IP Address
- `::1/10` - CIDR Notation
- `*` - ALL Addresses

To customize the error, return a `Response` in the third argument.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { ipRestriction } from 'hono/ip-restriction'
```

Example 2 (ts):
```ts
import { Hono } from 'hono'
import { getConnInfo } from 'hono/bun'
import { ipRestriction } from 'hono/ip-restriction'

const app = new Hono()

app.use(
  '*',
  ipRestriction(getConnInfo, {
    denyList: [],
    allowList: ['127.0.0.1', '::1'],
  })
)

app.get('/', (c) => c.text('Hello Hono!'))
```

Example 3 (ts):
```ts
import { getConnInfo } from 'hono/deno'
import { ipRestriction } from 'hono/ip-restriction'

//...

app.use(
  '*',
  ipRestriction(getConnInfo, {
    // ...
  })
)
```

Example 4 (ts):
```ts
app.use(
  '*',
  ipRestriction(
    getConnInfo,
    {
      denyList: ['192.168.2.0/24'],
    },
    async (remote, c) => {
      return c.text(`Blocking access from ${remote.addr}`, 403)
    }
  )
)
```

---

## JSX

**URL:** llms-txt#jsx

**Contents:**
- Settings
- Usage
- Metadata hoisting
- Fragment
- `PropsWithChildren`
- Inserting Raw HTML
- Memoization
- Context
- Async Component
- Suspense <Badge style="vertical-align: middle;" type="warning" text="Experimental" />

You can write HTML with JSX syntax with `hono/jsx`.

Although `hono/jsx` works on the client, you will probably use it most often when rendering content on the server side. Here are some things related to JSX that are common to both server and client.

To use JSX, modify the `tsconfig.json`:

Alternatively, use the pragma directives:

For Deno, you have to modify the `deno.json` instead of the `tsconfig.json`:

:::info
If you are coming straight from the [Quick Start](/docs/#quick-start), the main file has a `.ts` extension - you need to change it to `.tsx` - otherwise you will not be able to run the application at all. You should additionally modify the `package.json` (or `deno.json` if you are using Deno) to reflect that change (e.g. instead of having `bun run --hot src/index.ts` in dev script, you should have `bun run --hot src/index.tsx`).
:::

You can write document metadata tags such as `<title>`, `<link>`, and `<meta>` directly inside your components. These tags will be automatically hoisted to the `<head>` section of the document. This is especially useful when the `<head>` element is rendered far from the component that determines the appropriate metadata.

Use Fragment to group multiple elements without adding extra nodes:

Or you can write it with `<></>` if it set up properly.

## `PropsWithChildren`

You can use `PropsWithChildren` to correctly infer a child element in a function component.

## Inserting Raw HTML

To directly insert HTML, use `dangerouslySetInnerHTML`:

Optimize your components by memoizing computed strings using `memo`:

By using `useContext`, you can share data globally across any level of the Component tree without passing values through props.

`hono/jsx` supports an Async Component, so you can use `async`/`await` in your component.
If you render it with `c.html()`, it will await automatically.

## Suspense <Badge style="vertical-align: middle;" type="warning" text="Experimental" />

The React-like `Suspense` feature is available.
If you wrap the async component with `Suspense`, the content in the fallback will be rendered first, and once the Promise is resolved, the awaited content will be displayed.
You can use it with `renderToReadableStream()`.

## ErrorBoundary <Badge style="vertical-align: middle;" type="warning" text="Experimental" />

You can catch errors in child components using `ErrorBoundary`.

In the example below, it will show the content specified in `fallback` if an error occurs.

`ErrorBoundary` can also be used with async components and `Suspense`.

## StreamingContext <Badge style="vertical-align: middle;" type="warning" text="Experimental" />

You can use `StreamingContext` to provide configuration for streaming components like `Suspense` and `ErrorBoundary`. This is useful for adding nonce values to script tags generated by these components for Content Security Policy (CSP).

The `scriptNonce` value will be automatically added to any `<script>` tags generated by `Suspense` and `ErrorBoundary` components.

## Integration with html Middleware

Combine the JSX and html middlewares for powerful templating.
For in-depth details, consult the [html middleware documentation](/docs/helpers/html).

## With JSX Renderer Middleware

The [JSX Renderer Middleware](/docs/middleware/builtin/jsx-renderer) allows you to create HTML pages more easily with the JSX.

## Override type definitions

You can override the type definition to add your custom elements and attributes.

**Examples:**

Example 1 (json):
```json
{
  "compilerOptions": {
    "jsx": "react-jsx",
    "jsxImportSource": "hono/jsx"
  }
}
```

Example 2 (ts):
```ts
/** @jsx jsx */
/** @jsxImportSource hono/jsx */
```

Example 3 (json):
```json
{
  "compilerOptions": {
    "jsx": "precompile",
    "jsxImportSource": "hono/jsx"
  }
}
```

Example 4 (tsx):
```tsx
import { Hono } from 'hono'
import type { FC } from 'hono/jsx'

const app = new Hono()

const Layout: FC = (props) => {
  return (
    <html>
      <body>{props.children}</body>
    </html>
  )
}

const Top: FC<{ messages: string[] }> = (props: {
  messages: string[]
}) => {
  return (
    <Layout>
      <h1>Hello Hono!</h1>
      <ul>
        {props.messages.map((message) => {
          return <li>{message}!!</li>
        })}
      </ul>
    </Layout>
  )
}

app.get('/', (c) => {
  const messages = ['Good Morning', 'Good Evening', 'Good Night']
  return c.html(<Top messages={messages} />)
})

export default app
```

---

## JSX Renderer Middleware

**URL:** llms-txt#jsx-renderer-middleware

**Contents:**
- Import
- Usage
- Options
  - <Badge type="info" text="optional" /> docType: `boolean` | `string`
  - <Badge type="info" text="optional" /> stream: `boolean` | `Record<string, string>`
- Nested Layouts
- `useRequestContext()`
- Extending `ContextRenderer`

JSX Renderer Middleware allows you to set up the layout when rendering JSX with the `c.render()` function, without the need for using `c.setRenderer()`. Additionally, it enables access to instances of Context within components through the use of `useRequestContext()`.

### <Badge type="info" text="optional" /> docType: `boolean` | `string`

If you do not want to add a DOCTYPE at the beginning of the HTML, set the `docType` option to `false`.

And you can specify the DOCTYPE.

### <Badge type="info" text="optional" /> stream: `boolean` | `Record<string, string>`

If you set it to `true` or provide a Record value, it will be rendered as a streaming response.

If `true` is set, the following headers are added:

You can customize the header values by specifying the Record values.

The `Layout` component enables nesting the layouts.

## `useRequestContext()`

`useRequestContext()` returns an instance of Context.

::: warning
You can't use `useRequestContext()` with the Deno's `precompile` JSX option. Use the `react-jsx`:

## Extending `ContextRenderer`

By defining `ContextRenderer` as shown below, you can pass additional content to the renderer. This is handy, for instance, when you want to change the contents of the head tag depending on the page.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { jsxRenderer, useRequestContext } from 'hono/jsx-renderer'
```

Example 2 (jsx):
```jsx
const app = new Hono()

app.get(
  '/page/*',
  jsxRenderer(({ children }) => {
    return (
      <html>
        <body>
          <header>Menu</header>
          <div>{children}</div>
        </body>
      </html>
    )
  })
)

app.get('/page/about', (c) => {
  return c.render(<h1>About me!</h1>)
})
```

Example 3 (tsx):
```tsx
app.use(
  '*',
  jsxRenderer(
    ({ children }) => {
      return (
        <html>
          <body>{children}</body>
        </html>
      )
    },
    { docType: false }
  )
)
```

Example 4 (tsx):
```tsx
app.use(
  '*',
  jsxRenderer(
    ({ children }) => {
      return (
        <html>
          <body>{children}</body>
        </html>
      )
    },
    {
      docType:
        '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">',
    }
  )
)
```

---

## JWK Auth Middleware

**URL:** llms-txt#jwk-auth-middleware

**Contents:**
- Import
- Usage
- Using `verifyWithJwks` outside of middleware
- Options
  - <Badge type="info" text="optional" /> keys: `HonoJsonWebKey[] | (c: Context) => Promise<HonoJsonWebKey[]>`
  - <Badge type="info" text="optional" /> jwks_uri: `string` | `(c: Context) => Promise<string>`
  - <Badge type="info" text="optional" /> allow_anon: `boolean`
  - <Badge type="info" text="optional" /> cookie: `string`
  - <Badge type="info" text="optional" /> headerName: `string`

The JWK Auth Middleware authenticates requests by verifying tokens using JWK (JSON Web Key). It checks for an `Authorization` header and other configured sources, such as cookies, if specified. Specifically, it validates tokens using the provided `keys`, retrieves keys from `jwks_uri` if specified, and supports token extraction from cookies if the `cookie` option is set.

:::info
The Authorization header sent from the client must have a specified scheme.

Example: `Bearer my.token.value` or `Basic my.token.value`
:::

## Using `verifyWithJwks` outside of middleware

The `verifyWithJwks` utility function can be used to verify JWT tokens outside of Hono's middleware context, such as in SvelteKit SSR pages or other server-side environments:

### <Badge type="info" text="optional" /> keys: `HonoJsonWebKey[] | (c: Context) => Promise<HonoJsonWebKey[]>`

The values of your public keys, or a function that returns them. The function receives the Context object.

### <Badge type="info" text="optional" /> jwks_uri: `string` | `(c: Context) => Promise<string>`

If this value is set, attempt to fetch JWKs from this URI, expecting a JSON response with `keys`, which are added to the provided `keys` option. You can also pass a callback function to dynamically determine the JWKS URI using the Context.

### <Badge type="info" text="optional" /> allow_anon: `boolean`

If this value is set to `true`, requests without a valid token will be allowed to pass through the middleware. Use `c.get('jwtPayload')` to check if the request is authenticated. The default is `false`.

### <Badge type="info" text="optional" /> cookie: `string`

If this value is set, then the value is retrieved from the cookie header using that value as a key, which is then validated as a token.

### <Badge type="info" text="optional" /> headerName: `string`

The name of the header to look for the JWT token. The default is `Authorization`.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { jwk } from 'hono/jwk'
import { verifyWithJwks } from 'hono/jwt'
```

Example 2 (ts):
```ts
const app = new Hono()

app.use(
  '/auth/*',
  jwk({
    jwks_uri: `https://${backendServer}/.well-known/jwks.json`,
  })
)

app.get('/auth/page', (c) => {
  return c.text('You are authorized')
})
```

Example 3 (ts):
```ts
const app = new Hono()

app.use(
  '/auth/*',
  jwk({
    jwks_uri: `https://${backendServer}/.well-known/jwks.json`,
  })
)

app.get('/auth/page', (c) => {
  const payload = c.get('jwtPayload')
  return c.json(payload) // eg: { "sub": "1234567890", "name": "John Doe", "iat": 1516239022 }
})
```

Example 4 (ts):
```ts
const app = new Hono()

app.use(
  '/auth/*',
  jwk({
    jwks_uri: (c) =>
      `https://${c.env.authServer}/.well-known/jwks.json`,
    allow_anon: true,
  })
)

app.get('/auth/page', (c) => {
  const payload = c.get('jwtPayload')
  return c.json(payload ?? { message: 'hello anon' })
})
```

---

## JWT Authentication Helper

**URL:** llms-txt#jwt-authentication-helper

**Contents:**
- Import
- `sign()`
  - Example
  - Options
- `verify()`
  - Example
  - Options
- `decode()`
  - Example
  - Options

This helper provides functions for encoding, decoding, signing, and verifying JSON Web Tokens (JWTs). JWTs are commonly used for authentication and authorization purposes in web applications. This helper offers robust JWT functionality with support for various cryptographic algorithms.

To use this helper, you can import it as follows:

::: info
[JWT Middleware](/docs/middleware/builtin/jwt) also import the `jwt` function from the `hono/jwt`.
:::

This function generates a JWT token by encoding a payload and signing it using the specified algorithm and secret.

#### <Badge type="danger" text="required" /> payload: `unknown`

The JWT payload to be signed. You can include other claims like in [Payload Validation](#payload-validation).

#### <Badge type="danger" text="required" /> secret: `string`

The secret key used for JWT verification or signing.

#### <Badge type="info" text="optional" /> alg: [AlgorithmTypes](#supported-algorithmtypes)

The algorithm used for JWT signing or verification. The default is HS256.

This function checks if a JWT token is genuine and still valid. It ensures the token hasn't been altered and checks validity only if you added [Payload Validation](#payload-validation).

#### <Badge type="danger" text="required" /> token: `string`

The JWT token to be verified.

#### <Badge type="danger" text="required" /> secret: `string`

The secret key used for JWT verification or signing.

#### <Badge type="info" text="optional" /> alg: [AlgorithmTypes](#supported-algorithmtypes)

The algorithm used for JWT signing or verification. The default is HS256.

#### <Badge type="info" text="optional" /> issuer: `string | RegExp`

The expected issuer used for JWT verification.

This function decodes a JWT token without performing signature verification. It extracts and returns the header and payload from the token.

#### <Badge type="danger" text="required" /> token: `string`

The JWT token to be decoded.

> The `decode` function allows you to inspect the header and payload of a JWT token _**without**_ performing verification. This can be useful for debugging or extracting information from JWT tokens.

## Payload Validation

When verifying a JWT token, the following payload validations are performed:

- `exp`: The token is checked to ensure it has not expired.
- `nbf`: The token is checked to ensure it is not being used before a specified time.
- `iat`: The token is checked to ensure it is not issued in the future.
- `iss`: The token is checked to ensure it has been issued by a trusted issuer.

Please ensure that your JWT payload includes these fields, as an object, if you intend to perform these checks during verification.

## Custom Error Types

The module also defines custom error types to handle JWT-related errors.

- `JwtAlgorithmNotImplemented`: Indicates that the requested JWT algorithm is not implemented.
- `JwtTokenInvalid`: Indicates that the JWT token is invalid.
- `JwtTokenNotBefore`: Indicates that the token is being used before its valid date.
- `JwtTokenExpired`: Indicates that the token has expired.
- `JwtTokenIssuedAt`: Indicates that the "iat" claim in the token is incorrect.
- `JwtTokenIssuer`: Indicates that the "iss" claim in the token is incorrect.
- `JwtTokenSignatureMismatched`: Indicates a signature mismatch in the token.

## Supported AlgorithmTypes

The module supports the following JWT cryptographic algorithms:

- `HS256`: HMAC using SHA-256
- `HS384`: HMAC using SHA-384
- `HS512`: HMAC using SHA-512
- `RS256`: RSASSA-PKCS1-v1_5 using SHA-256
- `RS384`: RSASSA-PKCS1-v1_5 using SHA-384
- `RS512`: RSASSA-PKCS1-v1_5 using SHA-512
- `PS256`: RSASSA-PSS using SHA-256 and MGF1 with SHA-256
- `PS384`: RSASSA-PSS using SHA-386 and MGF1 with SHA-386
- `PS512`: RSASSA-PSS using SHA-512 and MGF1 with SHA-512
- `ES256`: ECDSA using P-256 and SHA-256
- `ES384`: ECDSA using P-384 and SHA-384
- `ES512`: ECDSA using P-521 and SHA-512
- `EdDSA`: EdDSA using Ed25519

**Examples:**

Example 1 (ts):
```ts
import { decode, sign, verify } from 'hono/jwt'
```

Example 2 (ts):
```ts
sign(
  payload: unknown,
  secret: string,
  alg?: 'HS256';

): Promise<string>;
```

Example 3 (ts):
```ts
import { sign } from 'hono/jwt'

const payload = {
  sub: 'user123',
  role: 'admin',
  exp: Math.floor(Date.now() / 1000) + 60 * 5, // Token expires in 5 minutes
}
const secret = 'mySecretKey'
const token = await sign(payload, secret)
```

Example 4 (ts):
```ts
verify(
  token: string,
  secret: string,
  alg?: 'HS256';
  issuer?: string | RegExp;
): Promise<any>;
```

---

## JWT Auth Middleware

**URL:** llms-txt#jwt-auth-middleware

**Contents:**
- Import
- Usage
- Options
  - <Badge type="danger" text="required" /> secret: `string`
  - <Badge type="info" text="optional" /> cookie: `string`
  - <Badge type="info" text="optional" /> alg: `string`
  - <Badge type="info" text="optional" /> headerName: `string`
  - <Badge type="info" text="optional" /> verifyOptions: `VerifyOptions`

The JWT Auth Middleware provides authentication by verifying the token with JWT.
The middleware will check for an `Authorization` header if the `cookie` option is not set. You can customize the header name using the `headerName` option.

:::info
The Authorization header sent from the client must have a specified scheme.

Example: `Bearer my.token.value` or `Basic my.token.value`
:::

`jwt()` is just a middleware function. If you want to use an environment variable (eg: `c.env.JWT_SECRET`), you can use it as follows:

### <Badge type="danger" text="required" /> secret: `string`

A value of your secret key.

### <Badge type="info" text="optional" /> cookie: `string`

If this value is set, then the value is retrieved from the cookie header using that value as a key, which is then validated as a token.

### <Badge type="info" text="optional" /> alg: `string`

An algorithm type that is used for verifying. The default is `HS256`.

Available types are `HS256` | `HS384` | `HS512` | `RS256` | `RS384` | `RS512` | `PS256` | `PS384` | `PS512` | `ES256` | `ES384` | `ES512` | `EdDSA`.

### <Badge type="info" text="optional" /> headerName: `string`

The name of the header to look for the JWT token. The default is `Authorization`.

### <Badge type="info" text="optional" /> verifyOptions: `VerifyOptions`

Options controlling verification of the token.

#### <Badge type="info" text="optional" /> verifyOptions.iss: `string | RexExp`

The expected issuer used for token verification. The `iss` claim will **not** be checked if this isn't set.

#### <Badge type="info" text="optional" /> verifyOptions.nbf: `boolean`

The `nbf` (not before) claim will be verified if present and this is set to `true`. The default is `true`.

#### <Badge type="info" text="optional" /> verifyOptions.iat: `boolean`

The `iat` (not before) claim will be verified if present and this is set to `true`. The default is `true`.

#### <Badge type="info" text="optional" /> verifyOptions.exp: `boolean`

The `exp` (not before) claim will be verified if present and this is set to `true`. The default is `true`.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { jwt } from 'hono/jwt'
import type { JwtVariables } from 'hono/jwt'
```

Example 2 (ts):
```ts
// Specify the variable types to infer the `c.get('jwtPayload')`:
type Variables = JwtVariables

const app = new Hono<{ Variables: Variables }>()

app.use(
  '/auth/*',
  jwt({
    secret: 'it-is-very-secret',
  })
)

app.get('/auth/page', (c) => {
  return c.text('You are authorized')
})
```

Example 3 (ts):
```ts
const app = new Hono()

app.use(
  '/auth/*',
  jwt({
    secret: 'it-is-very-secret',
    issuer: 'my-trusted-issuer',
  })
)

app.get('/auth/page', (c) => {
  const payload = c.get('jwtPayload')
  return c.json(payload) // eg: { "sub": "1234567890", "name": "John Doe", "iat": 1516239022, "iss": "my-trusted-issuer" }
})
```

Example 4 (js):
```js
app.use('/auth/*', (c, next) => {
  const jwtMiddleware = jwt({
    secret: c.env.JWT_SECRET,
  })
  return jwtMiddleware(c, next)
})
```

---

## Lambda@Edge

**URL:** llms-txt#lambda@edge

**Contents:**
- 1. Setup
- 2. Hello World
- 3. Deploy
- Callback

[Lambda@Edge](https://aws.amazon.com/lambda/edge/) is a serverless platform by Amazon Web Services. It allows you to run Lambda functions at Amazon CloudFront's edge locations, enabling you to customize behaviors for HTTP requests/responses.

Hono supports Lambda@Edge with the Node.js 18+ environment.

When creating the application on Lambda@Edge,
[CDK](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-cdk.html)
is useful to setup the functions such as CloudFront, IAM Role, API Gateway, and others.

Initialize your project with the `cdk` CLI.

Edit `lambda/index_edge.ts`.

Edit `bin/my-app.ts`.

Edit `lambda/cdk-stack.ts`.

Finally, run the command to deploy:

If you want to add Basic Auth and continue with request processing after verification, you can use `c.env.callback()`

**Examples:**

Example 1 (unknown):
```unknown

```

Example 2 (unknown):
```unknown

```

Example 3 (unknown):
```unknown

```

Example 4 (unknown):
```unknown
:::

## 2. Hello World

Edit `lambda/index_edge.ts`.
```

---

## Language Middleware

**URL:** llms-txt#language-middleware

**Contents:**
- Import
- Basic Usage
  - Client Examples

The Language Detector middleware automatically determines a user's preferred language (locale) from various sources and makes it available via `c.get('language')`. Detection strategies include query parameters, cookies, headers, and URL path segments. Perfect for internationalization (i18n) and locale-specific content.

Detect language from query string, cookie, and header (default order), with fallback to English:

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { languageDetector } from 'hono/language'
```

Example 2 (ts):
```ts
const app = new Hono()

app.use(
  languageDetector({
    supportedLanguages: ['en', 'ar', 'ja'], // Must include fallback
    fallbackLanguage: 'en', // Required
  })
)

app.get('/', (c) => {
  const lang = c.get('language')
  return c.text(`Hello! Your language is ${lang}`)
})
```

---

## Logger Middleware

**URL:** llms-txt#logger-middleware

**Contents:**
- Import
- Usage
- Logging Details
- PrintFunc
- Options
  - <Badge type="info" text="optional" /> fn: `PrintFunc(str: string, ...rest: string[])`
  - Example

It's a simple logger.

The Logger Middleware logs the following details for each request:

- **Incoming Request**: Logs the HTTP method, request path, and incoming request.
- **Outgoing Response**: Logs the HTTP method, request path, response status code, and request/response times.
- **Status Code Coloring**: Response status codes are color-coded for better visibility and quick identification of status categories. Different status code categories are represented by different colors.
- **Elapsed Time**: The time taken for the request/response cycle is logged in a human-readable format, either in milliseconds (ms) or seconds (s).

By using the Logger Middleware, you can easily monitor the flow of requests and responses in your Hono application and quickly identify any issues or performance bottlenecks.

You can also extend the middleware further by providing your own `PrintFunc` function for tailored logging behavior.

The Logger Middleware accepts an optional `PrintFunc` function as a parameter. This function allows you to customize the logger and add additional logs.

### <Badge type="info" text="optional" /> fn: `PrintFunc(str: string, ...rest: string[])`

- `str`: Passed by the logger.
- `...rest`: Additional string props to be printed to console.

Setting up a custom `PrintFunc` function to the Logger Middleware:

Setting up the custom logger in a route:

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { logger } from 'hono/logger'
```

Example 2 (ts):
```ts
const app = new Hono()

app.use(logger())
app.get('/', (c) => c.text('Hello Hono!'))
```

Example 3 (ts):
```ts
export const customLogger = (message: string, ...rest: string[]) => {
  console.log(message, ...rest)
}

app.use(logger(customLogger))
```

Example 4 (ts):
```ts
app.post('/blog', (c) => {
  // Routing logic

  customLogger('Blog saved:', `Path: ${blog.url},`, `ID: ${blog.id}`)
  // Output
  // <-- POST /blog
  // Blog saved: Path: /blog/example, ID: 1
  // --> POST /blog 201 93ms

  // Return Context
})
```

---

## Method Override Middleware

**URL:** llms-txt#method-override-middleware

**Contents:**
- Import
- Usage
- For example
- Options
  - <Badge type="danger" text="required" /> app: `Hono`
  - <Badge type="info" text="optional" /> form: `string`
  - <Badge type="info" text="optional" /> header: `boolean`
  - <Badge type="info" text="optional" /> query: `boolean`

This middleware executes the handler of the specified method, which is different from the actual method of the request, depending on the value of the form, header, or query, and returns its response.

Since HTML forms cannot send a DELETE method, you can put the value `DELETE` in the property named `_method` and send it. And the handler for `app.delete()` will be executed.

You can change the default values or use the header value and query value:

### <Badge type="danger" text="required" /> app: `Hono`

The instance of `Hono` is used in your application.

### <Badge type="info" text="optional" /> form: `string`

Form key with a value containing the method name.
The default is `_method`.

### <Badge type="info" text="optional" /> header: `boolean`

Header name with a value containing the method name.

### <Badge type="info" text="optional" /> query: `boolean`

Query parameter key with a value containing the method name.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { methodOverride } from 'hono/method-override'
```

Example 2 (ts):
```ts
const app = new Hono()

// If no options are specified, the value of `_method` in the form,
// e.g. DELETE, is used as the method.
app.use('/posts', methodOverride({ app }))

app.delete('/posts', (c) => {
  // ....
})
```

Example 3 (html):
```html
<form action="/posts" method="POST">
  <input type="hidden" name="_method" value="DELETE" />
  <input type="text" name="id" />
</form>
```

Example 4 (ts):
```ts
import { methodOverride } from 'hono/method-override'

const app = new Hono()
app.use('/posts', methodOverride({ app }))

app.delete('/posts', () => {
  // ...
})
```

---

## Middleware

**URL:** llms-txt#middleware

We call the primitive that returns `Response` as "Handler".
"Middleware" is executed before and after the Handler and handles the `Request` and `Response`.
It's like an onion structure.

![](/images/onion.png)

For example, we can write the middleware to add the "X-Response-Time" header as follows.

With this simple method, we can write our own custom middleware and we can use the built-in or third party middleware.

---

## Miscellaneous

**URL:** llms-txt#miscellaneous

**Contents:**
- Contributing
- Sponsoring
- Other Resources

Contributions Welcome! You can contribute in the following ways.

- Create an Issue - Propose a new feature. Report a bug.
- Pull Request - Fix a bug and typo. Refactor the code.
- Create third-party middleware - Instruct below.
- Share - Share your thoughts on the Blog, X(Twitter), and others.
- Make your application - Please try to use Hono.

For more details, see [Contribution Guide](https://github.com/honojs/hono/blob/main/docs/CONTRIBUTING.md).

You can sponsor Hono authors via the GitHub sponsor program.

- [Sponsor @yusukebe on GitHub Sponsors](https://github.com/sponsors/yusukebe)
- [Sponsor @usualoma on GitHub Sponsors](https://github.com/sponsors/usualoma)

- GitHub repository: <a href="https://github.com/honojs">https://github.com/honojs</a>
- npm registry: <a href="https://www.npmjs.com/package/hono">https://www.npmjs.com/package/hono</a>
- JSR: <a href="https://jsr.io/@hono/hono">https://jsr.io/@hono/hono</a>

---

## Netlify

**URL:** llms-txt#netlify

**Contents:**
- 1. Setup
- 2. Hello World
- 3. Run
- 4. Deploy
- `Context`

Netlify provides static site hosting and serverless backend services. [Edge Functions](https://docs.netlify.com/edge-functions/overview/) enables us to make the web pages dynamic.

Edge Functions support writing in Deno and TypeScript, and deployment is made easy through the [Netlify CLI](https://docs.netlify.com/cli/get-started/). With Hono, you can create the application for Netlify Edge Functions.

A starter for Netlify is available.
Start your project with "create-hono" command.
Select `netlify` template for this example.

Edit `netlify/edge-functions/index.ts`:

Run the development server with Netlify CLI. Then, access `http://localhost:8888` in your Web browser.

You can deploy with a `netlify deploy` command.

You can access the Netlify's `Context` through `c.env`:

**Examples:**

Example 1 (unknown):
```unknown

```

Example 2 (unknown):
```unknown

```

Example 3 (unknown):
```unknown

```

Example 4 (unknown):
```unknown

```

---

## Next.js

**URL:** llms-txt#next.js

**Contents:**
- 1. Setup
- 2. Hello World
- 3. Run
- 4. Deploy
- Pages Router

Next.js is a flexible React framework that gives you building blocks to create fast web applications.

You can run Hono on Next.js when using the Node.js runtime.\
On Vercel, deploying Hono with Next.js is easy by using Vercel Functions.

A starter for Next.js is available.
Start your project with "create-hono" command.
Select `nextjs` template for this example.

Move into `my-app` and install the dependencies.

If you use the App Router, Edit `app/api/[[...route]]/route.ts`. Refer to the [Supported HTTP Methods](https://nextjs.org/docs/app/building-your-application/routing/route-handlers#supported-http-methods) section for more options.

Run the development server locally. Then, access `http://localhost:3000` in your Web browser.

Now, `/api/hello` just returns JSON, but if you build React UIs, you can create a full-stack application with Hono.

If you have a Vercel account, you can deploy by linking the Git repository.

If you use the Pages Router, you'll need to install the Node.js adapter first.

Then, you can utilize the `handle` function imported from `@hono/node-server/vercel` in `pages/api/[[...route]].ts`.

In order for this to work with the Pages Router, it's important to disable Vercel Node.js helpers by setting up an environment variable in your project dashboard or in your `.env` file.

**Examples:**

Example 1 (unknown):
```unknown

```

Example 2 (unknown):
```unknown

```

Example 3 (unknown):
```unknown

```

Example 4 (unknown):
```unknown

```

---

## Node.js

**URL:** llms-txt#node.js

**Contents:**
- 1. Setup
- 2. Hello World
- 3. Run
- Change port number
- Access the raw Node.js APIs
- Serve static files
  - `rewriteRequestPath`
- http2
  - unencrypted http2
  - encrypted http2

[Node.js](https://nodejs.org/) is an open-source, cross-platform JavaScript runtime environment.

Hono was not designed for Node.js at first. But with a [Node.js Adapter](https://github.com/honojs/node-server) it can run on Node.js as well.

::: info
It works on Node.js versions greater than 18.x. The specific required Node.js versions are as follows:

- 18.x => 18.14.1+
- 19.x => 19.7.0+
- 20.x => 20.0.0+

Essentially, you can simply use the latest version of each major release.
:::

A starter for Node.js is available.
Start your project with "create-hono" command.
Select `nodejs` template for this example.

:::
Move to `my-app` and install the dependencies.

If you want to gracefully shut down the server, write it like this:

Run the development server locally. Then, access `http://localhost:3000` in your Web browser.

## Change port number

You can specify the port number with the `port` option.

## Access the raw Node.js APIs

You can access the Node.js APIs from `c.env.incoming` and `c.env.outgoing`.

## Serve static files

You can use `serveStatic` to serve static files from the local file system. For example, suppose the directory structure is as follows:

If a request to the path `/static/*` comes in and you want to return a file under `./static`, you can write the following:

Use the `path` option to serve `favicon.ico` in the directory root:

If a request to the path `/hello.txt` or `/image.png` comes in and you want to return a file named `./static/hello.txt` or `./static/image.png`, you can use the following:

### `rewriteRequestPath`

If you want to map `http://localhost:3000/static/*` to `./statics`, you can use the `rewriteRequestPath` option:

You can run hono on a [Node.js http2 Server](https://nodejs.org/api/http2.html).

### unencrypted http2

## Building & Deployment

::: info
Apps with a front-end framework may need to use [Hono's Vite plugins](https://github.com/honojs/vite-plugins).
:::

Here is an example of a nodejs Dockerfile.

**Examples:**

Example 1 (unknown):
```unknown

```

Example 2 (unknown):
```unknown

```

Example 3 (unknown):
```unknown

```

Example 4 (unknown):
```unknown

```

---

## Philosophy

**URL:** llms-txt#philosophy

**Contents:**
- Motivation

In this section, we talk about the concept, or philosophy, of Hono.

At first, I just wanted to create a web application on Cloudflare Workers.
But, there was no good framework that works on Cloudflare Workers.
So, I started building Hono.

I thought it would be a good opportunity to learn how to build a router using Trie trees.
Then a friend showed up with ultra crazy fast router called "RegExpRouter".
And I also have a friend who created the Basic authentication middleware.

Using only Web Standard APIs, we could make it work on Deno and Bun. When people asked "is there Express for Bun?", we could answer, "no, but there is Hono".
(Although Express works on Bun now.)

We also have friends who make GraphQL servers, Firebase authentication, and Sentry middleware.
And, we also have a Node.js adapter.
An ecosystem has sprung up.

In other words, Hono is damn fast, makes a lot of things possible, and works anywhere.
We might imagine that Hono could become the **Standard for Web Standards**.

---

## Please select a provider: Alibaba Cloud (alibaba)

**URL:** llms-txt#please-select-a-provider:-alibaba-cloud-(alibaba)

---

## Presets

**URL:** llms-txt#presets

**Contents:**
- `hono`
- `hono/quick`
- `hono/tiny`
- Which preset should I use?

Hono has several routers, each designed for a specific purpose.
You can specify the router you want to use in the constructor of Hono.

**Presets** are provided for common use cases, so you don't have to specify the router each time.
The `Hono` class imported from all presets is the same, the only difference being the router.
Therefore, you can use them interchangeably.

## Which preset should I use?

| Preset       | Suitable platforms                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `hono`       | This is highly recommended for most use cases. Although the registration phase may be slower than `hono/quick`, it exhibits high performance once booted. It's ideal for long-life servers built with **Deno**, **Bun**, or **Node.js**. It is also suitable for **Fastly Compute**, as route registration occurs during the app build phase on that platform. For environments such as **Cloudflare Workers**, **Deno Deploy**, where v8 isolates are utilized, this preset is suitable as well. Because the isolations persist for a certain amount of time after booting. |
| `hono/quick` | This preset is designed for environments where the application is initialized for every request.                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| `hono/tiny`  | This is the smallest router package and it's suitable for environments where resources are limited.                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |

**Examples:**

Example 1 (unknown):
```unknown
Routers:
```

Example 2 (unknown):
```unknown
## `hono/quick`

Usage:
```

Example 3 (unknown):
```unknown
Router:
```

Example 4 (unknown):
```unknown
## `hono/tiny`

Usage:
```

---

## Pretty JSON Middleware

**URL:** llms-txt#pretty-json-middleware

**Contents:**
- Import
- Usage
- Options
  - <Badge type="info" text="optional" /> space: `number`
  - <Badge type="info" text="optional" /> query: `string`

Pretty JSON middleware enables "_JSON pretty print_" for JSON response body.
Adding `?pretty` to url query param, the JSON strings are prettified.

### <Badge type="info" text="optional" /> space: `number`

Number of spaces for indentation. The default is `2`.

### <Badge type="info" text="optional" /> query: `string`

The name of the query string for applying. The default is `pretty`.

**Examples:**

Example 1 (js):
```js
// GET /
{"project":{"name":"Hono","repository":"https://github.com/honojs/hono"}}
```

Example 2 (js):
```js
// GET /?pretty
{
  "project": {
    "name": "Hono",
    "repository": "https://github.com/honojs/hono"
  }
}
```

Example 3 (ts):
```ts
import { Hono } from 'hono'
import { prettyJSON } from 'hono/pretty-json'
```

Example 4 (ts):
```ts
const app = new Hono()

app.use(prettyJSON()) // With options: prettyJSON({ space: 4 })
app.get('/', (c) => {
  return c.json({ message: 'Hono!' })
})
```

---

## Proxy Helper

**URL:** llms-txt#proxy-helper

**Contents:**
- Import
- `proxy()`
  - Examples
  - Connection Header Processing
  - `ProxyFetch`

Proxy Helper provides useful functions when using Hono application as a (reverse) proxy.

`proxy()` is a `fetch()` API wrapper for proxy. The parameters and return value are the same as for `fetch()` (except for the proxy-specific options).

The `Accept-Encoding` header is replaced with an encoding that the current runtime can handle. Unnecessary response headers are deleted, and a `Response` object is returned that you can return as a response from the handler.

Or you can pass the `c.req` as a parameter.

You can override the default global `fetch` function with the `customFetch` option:

### Connection Header Processing

By default, `proxy()` ignores the `Connection` header to prevent Hop-by-Hop Header Injection attacks. You can enable strict RFC 9110 compliance with the `strictConnectionProcessing` option:

The type of `proxy()` is defined as `ProxyFetch` and is as follows

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { proxy } from 'hono/proxy'
```

Example 2 (ts):
```ts
app.get('/proxy/:path', (c) => {
  return proxy(`http://${originServer}/${c.req.param('path')}`)
})
```

Example 3 (ts):
```ts
app.get('/proxy/:path', async (c) => {
  const res = await proxy(
    `http://${originServer}/${c.req.param('path')}`,
    {
      headers: {
        ...c.req.header(), // optional, specify only when forwarding all the request data (including credentials) is necessary.
        'X-Forwarded-For': '127.0.0.1',
        'X-Forwarded-Host': c.req.header('host'),
        Authorization: undefined, // do not propagate request headers contained in c.req.header('Authorization')
      },
    }
  )
  res.headers.delete('Set-Cookie')
  return res
})
```

Example 4 (ts):
```ts
app.all('/proxy/:path', (c) => {
  return proxy(`http://${originServer}/${c.req.param('path')}`, {
    ...c.req, // optional, specify only when forwarding all the request data (including credentials) is necessary.
    headers: {
      ...c.req.header(),
      'X-Forwarded-For': '127.0.0.1',
      'X-Forwarded-Host': c.req.header('host'),
      Authorization: undefined, // do not propagate request headers contained in c.req.header('Authorization')
    },
  })
})
```

---

## Request ID Middleware

**URL:** llms-txt#request-id-middleware

**Contents:**
- Import
- Usage
  - Set Request ID
- Options
  - <Badge type="info" text="optional" /> limitLength: `number`
  - <Badge type="info" text="optional" /> headerName: `string`
  - <Badge type="info" text="optional" /> generator: `(c: Context) => string`
- Platform specific Request IDs
  - Platform specific links

Request ID Middleware generates a unique ID for each request, which you can use in your handlers.

::: info
**Node.js**: This middleware uses `crypto.randomUUID()` to generate IDs. The global `crypto` was introduced in Node.js version 20 or later. Therefore, errors may occur in versions earlier than that. In that case, please specify `generator`. However, if you are using [the Node.js adapter](https://github.com/honojs/node-server), it automatically sets `crypto` globally, so this is not necessary.
:::

You can access the Request ID through the `requestId` variable in the handlers and middleware to which the Request ID Middleware is applied.

If you want to explicitly specify the type, import `RequestIdVariables` and pass it in the generics of `new Hono()`.

You set a custom request ID in the header (default: `X-Request-Id`), the middleware will use that value instead of generating a new one:

If you want to disable this feature, set [`headerName` option](#headername-string) to an empty string.

### <Badge type="info" text="optional" /> limitLength: `number`

The maximum length of the request ID. The default is `255`.

### <Badge type="info" text="optional" /> headerName: `string`

The header name used for the request ID. The default is `X-Request-Id`.

### <Badge type="info" text="optional" /> generator: `(c: Context) => string`

The request ID generation function. By default, it uses `crypto.randomUUID()`.

## Platform specific Request IDs

Some platform (such as AWS Lambda) already generate their own Request IDs per request.
Without any additional configuration, this middleware is unaware of these specific Request IDs
and generates a new Request ID. This can lead to confusion when looking at your application logs.

To unify these IDs, use the `generator` function to capture the platform specific Request ID and to use it in this middleware.

### Platform specific links

- AWS Lambda
  - [AWS documentation: Context object](https://docs.aws.amazon.com/lambda/latest/dg/nodejs-context.html)
  - [Hono: Access AWS Lambda Object](/docs/getting-started/aws-lambda#access-aws-lambda-object)
- Cloudflare
  - [Cloudflare Ray ID
    ](https://developers.cloudflare.com/fundamentals/reference/cloudflare-ray-id/)
- Deno
  - [Request ID on the Deno Blog](https://deno.com/blog/zero-config-debugging-deno-opentelemetry#:~:text=s%20automatically%20have-,unique%20request%20IDs,-associated%20with%20them)
- Fastly
  - [Fastly documentation: req.xid](https://www.fastly.com/documentation/reference/vcl/variables/client-request/req-xid/)

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { requestId } from 'hono/request-id'
```

Example 2 (ts):
```ts
const app = new Hono()

app.use('*', requestId())

app.get('/', (c) => {
  return c.text(`Your request id is ${c.get('requestId')}`)
})
```

Example 3 (ts):
```ts
import type { RequestIdVariables } from 'hono/request-id'

const app = new Hono<{
  Variables: RequestIdVariables
}>()
```

Example 4 (ts):
```ts
const app = new Hono()

app.use('*', requestId())

app.get('/', (c) => {
  return c.text(`${c.get('requestId')}`)
})

const res = await app.request('/', {
  headers: {
    'X-Request-Id': 'your-custom-id',
  },
})
console.log(await res.text()) // your-custom-id
```

---

## Routers

**URL:** llms-txt#routers

**Contents:**
- RegExpRouter
- TrieRouter
- SmartRouter
- LinearRouter
- PatternRouter

The routers are the most important features for Hono.

Hono has five routers.

**RegExpRouter** is the fastest router in the JavaScript world.

Although this is called "RegExp" it is not an Express-like implementation using [path-to-regexp](https://github.com/pillarjs/path-to-regexp).
They are using linear loops.
Therefore, regular expression matching will be performed for all routes and the performance will be degraded as you have more routes.

![](/images/router-linear.jpg)

Hono's RegExpRouter turns the route pattern into "one large regular expression".
Then it can get the result with one-time matching.

![](/images/router-regexp.jpg)

This works faster than methods that use tree-based algorithms such as radix-tree in most cases.

However, RegExpRouter doesn't support all routing patterns, so it's usually used in combination with one of the other routers below that support all routing patterns.

**TrieRouter** is the router using the Trie-tree algorithm.
Like RegExpRouter, it does not use linear loops.

![](/images/router-tree.jpg)

This router is not as fast as the RegExpRouter, but it is much faster than the Express router.
TrieRouter supports all patterns.

**SmartRouter** is useful when you're using multiple routers. It selects the best router by inferring from the registered routers.
Hono uses SmartRouter, RegExpRouter, and TrieRouter by default:

When the application starts, SmartRouter detects the fastest router based on routing and continues to use it.

RegExpRouter is fast, but the route registration phase can be slightly slow.
So, it's not suitable for an environment that initializes with every request.

**LinearRouter** is optimized for "one shot" situations.
Route registration is significantly faster than with RegExpRouter because it adds the route without compiling strings, using a linear approach.

The following is one of the benchmark results, which includes the route registration phase.

**PatternRouter** is the smallest router among Hono's routers.

While Hono is already compact, if you need to make it even smaller for an environment with limited resources, use PatternRouter.

An application using only PatternRouter is under 15KB in size.

**Examples:**

Example 1 (ts):
```ts
// Inside the core of Hono.
readonly defaultRouter: Router = new SmartRouter({
  routers: [new RegExpRouter(), new TrieRouter()],
})
```

Example 2 (console):
```console
• GET /user/lookup/username/hey
----------------------------------------------------- -----------------------------
LinearRouter     1.82 µs/iter      (1.7 µs … 2.04 µs)   1.84 µs   2.04 µs   2.04 µs
MedleyRouter     4.44 µs/iter     (4.34 µs … 4.54 µs)   4.48 µs   4.54 µs   4.54 µs
FindMyWay       60.36 µs/iter      (45.5 µs … 1.9 ms)  59.88 µs  78.13 µs  82.92 µs
KoaTreeRouter    3.81 µs/iter     (3.73 µs … 3.87 µs)   3.84 µs   3.87 µs   3.87 µs
TrekRouter       5.84 µs/iter     (5.75 µs … 6.04 µs)   5.86 µs   6.04 µs   6.04 µs

summary for GET /user/lookup/username/hey
  LinearRouter
   2.1x faster than KoaTreeRouter
   2.45x faster than MedleyRouter
   3.21x faster than TrekRouter
   33.24x faster than FindMyWay
```

Example 3 (console):
```console
$ npx wrangler deploy --minify ./src/index.ts
 ⛅️ wrangler 3.20.0
-------------------
Total Upload: 14.68 KiB / gzip: 5.38 KiB
```

---

## Route Helper

**URL:** llms-txt#route-helper

**Contents:**
- Import
- Usage
  - Basic route information
  - Working with sub-applications
- `matchedRoutes()`
- `routePath()`
  - Using with index parameter
- `baseRoutePath()`
  - Using with index parameter
- `basePath()`

The Route Helper provides enhanced routing information for debugging and middleware development. It allows you to access detailed information about matched routes and the current route being processed.

### Basic route information

### Working with sub-applications

Returns an array of all routes that matched the current request, including middleware.

Returns the route path pattern registered for the current handler.

### Using with index parameter

You can optionally pass an index parameter to get the route path at a specific position, similar to `Array.prototype.at()`.

Returns the base path pattern of the current route as specified in routing.

### Using with index parameter

You can optionally pass an index parameter to get the base route path at a specific
position, similar to `Array.prototype.at()`.

Returns the base path with embedded parameters from the actual request.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import {
  matchedRoutes,
  routePath,
  baseRoutePath,
  basePath,
} from 'hono/route'
```

Example 2 (ts):
```ts
const app = new Hono()

app.get('/posts/:id', (c) => {
  const currentPath = routePath(c) // '/posts/:id'
  const routes = matchedRoutes(c) // Array of matched routes

  return c.json({
    path: currentPath,
    totalRoutes: routes.length,
  })
})
```

Example 3 (ts):
```ts
const app = new Hono()
const apiApp = new Hono()

apiApp.get('/posts/:id', (c) => {
  return c.json({
    routePath: routePath(c), // '/posts/:id'
    baseRoutePath: baseRoutePath(c), // '/api'
    basePath: basePath(c), // '/api' (with actual params)
  })
})

app.route('/api', apiApp)
```

Example 4 (ts):
```ts
app.all('/api/*', (c, next) => {
  console.log('API middleware')
  return next()
})

app.get('/api/users/:id', (c) => {
  const routes = matchedRoutes(c)
  // Returns: [
  //   { method: 'ALL', path: '/api/*', handler: [Function] },
  //   { method: 'GET', path: '/api/users/:id', handler: [Function] }
  // ]
  return c.json({ routes: routes.length })
})
```

---

## Routing

**URL:** llms-txt#routing

**Contents:**
- Basic
- Path Parameter
- Optional Parameter
- Regexp
- Including slashes
- Chained route
- Grouping
- Grouping without changing base
- Base path
- Routing with hostname

Routing of Hono is flexible and intuitive.
Let's take a look.

or all parameters at once:

## Optional Parameter

You can group the routes with the Hono instance and add them to the main app with the route method.

## Grouping without changing base

You can also group multiple instances while keeping base.

You can specify the base path.

## Routing with hostname

It works fine if it includes a hostname.

## Routing with `host` Header value

Hono can handle the `host` header value if you set the `getPath()` function in the Hono constructor.

By applying this, for example, you can change the routing by `User-Agent` header.

Handlers or middleware will be executed in registration order.

When a handler is executed, the process will be stopped.

If you have the middleware that you want to execute, write the code above the handler.

If you want to have a "_fallback_" handler, write the code below the other handler.

Note that the mistake of grouping routings is hard to notice.
The `route()` function takes the stored routing from the second argument (such as `three` or `two`) and adds it to its own (`two` or `app`) routing.

It will return 200 response.

However, if they are in the wrong order, it will return a 404.

**Examples:**

Example 1 (unknown):
```unknown
## Path Parameter
```

Example 2 (unknown):
```unknown
or all parameters at once:
```

Example 3 (unknown):
```unknown
## Optional Parameter
```

Example 4 (unknown):
```unknown
## Regexp
```

---

## RPC

**URL:** llms-txt#rpc

**Contents:**
- Server
- Client
  - Cookies
- Status code
- Not Found
- Path parameters
  - Include slashes
- Headers
- `init` option
- `$url()`

The RPC feature allows sharing of the API specifications between the server and the client.

First, export the `typeof` your Hono app (commonly called `AppType`)—or just the routes you want available to the client—from your server code.

By accepting `AppType` as a generic parameter, the Hono Client can infer both the input type(s) specified by the Validator, and the output type(s) emitted by handlers returning `c.json()`.

> [!NOTE]
> For the RPC types to work properly in a monorepo, in both the Client's and Server's tsconfig.json files, set `"strict": true` in `compilerOptions`. [Read more.](https://github.com/honojs/hono/issues/2270#issuecomment-2143745118)

All you need to do on the server side is to write a validator and create a variable `route`. The following example uses [Zod Validator](https://github.com/honojs/middleware/tree/main/packages/zod-validator).

Then, export the type to share the API spec with the Client.

On the Client side, import `hc` and `AppType` first.

`hc` is a function to create a client. Pass `AppType` as Generics and specify the server URL as an argument.

Call `client.{path}.{method}` and pass the data you wish to send to the server as an argument.

The `res` is compatible with the "fetch" Response. You can retrieve data from the server with `res.json()`.

To make the client send cookies with every request, add `{ 'init': { 'credentials": 'include' } }` to the options when you're creating the client.

If you explicitly specify the status code, such as `200` or `404`, in `c.json()`. It will be added as a type for passing to the client.

You can get the data by the status code.

If you want to use a client, you should not use `c.notFound()` for the Not Found response. The data that the client gets from the server cannot be inferred correctly.

Please use `c.json()` and specify the status code for the Not Found Response.

You can also handle routes that include path parameters.

Specify the string you want to include in the path with `param`.

`hc` function does not URL-encode the values of `param`. To include slashes in parameters, use [regular expressions](/docs/api/routing#regexp).

> [!NOTE]
> Basic path parameters without regular expressions do not match slashes. If you pass a `param` containing slashes using the hc function, the server might not route as intended. Encoding the parameters using `encodeURIComponent` is the recommended approach to ensure correct routing.

You can append the headers to the request.

To add a common header to all requests, specify it as an argument to the `hc` function.

You can pass the fetch's `RequestInit` object to the request as the `init` option. Below is an example of aborting a Request.

::: info
A `RequestInit` object defined by `init` takes the highest priority. It could be used to overwrite things set by other options like `body | method | headers`.
:::

You can get a `URL` object for accessing the endpoint by using `$url()`.

::: warning
You have to pass in an absolute URL for this to work. Passing in a relative URL `/` will result in the following error.

`Uncaught TypeError: Failed to construct 'URL': Invalid URL`

You can upload files using a form body:

## Custom `fetch` method

You can set the custom `fetch` method.

In the following example script for Cloudflare Worker, the Service Bindings' `fetch` method is used instead of the default `fetch`.

**Examples:**

Example 1 (unknown):
```unknown
Then, export the type to share the API spec with the Client.
```

Example 2 (unknown):
```unknown
## Client

On the Client side, import `hc` and `AppType` first.
```

Example 3 (unknown):
```unknown
`hc` is a function to create a client. Pass `AppType` as Generics and specify the server URL as an argument.
```

Example 4 (unknown):
```unknown
Call `client.{path}.{method}` and pass the data you wish to send to the server as an argument.
```

---

## Secure Headers Middleware

**URL:** llms-txt#secure-headers-middleware

**Contents:**
- Import
- Usage
- Supported Options
- Middleware Conflict
- Setting Content-Security-Policy
  - `nonce` attribute
- Setting Permission-Policy

Secure Headers Middleware simplifies the setup of security headers. Inspired in part by the capabilities of Helmet, it allows you to control the activation and deactivation of specific security headers.

You can use the optimal settings by default.

You can suppress unnecessary headers by setting them to false.

You can override default header values using a string.

Each option corresponds to the following Header Key-Value pairs.

| Option                          | Header                                                                                                                                         | Value                                                                      | Default    |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- | ---------- |
| -                               | X-Powered-By                                                                                                                                   | (Delete Header)                                                            | True       |
| contentSecurityPolicy           | [Content-Security-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)                                                               | Usage: [Setting Content-Security-Policy](#setting-content-security-policy) | No Setting |
| contentSecurityPolicyReportOnly | [Content-Security-Policy-Report-Only](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only)           | Usage: [Setting Content-Security-Policy](#setting-content-security-policy) | No Setting |
| crossOriginEmbedderPolicy       | [Cross-Origin-Embedder-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cross-Origin-Embedder-Policy)                         | require-corp                                                               | **False**  |
| crossOriginResourcePolicy       | [Cross-Origin-Resource-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cross-Origin-Resource-Policy)                         | same-origin                                                                | True       |
| crossOriginOpenerPolicy         | [Cross-Origin-Opener-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cross-Origin-Opener-Policy)                             | same-origin                                                                | True       |
| originAgentCluster              | [Origin-Agent-Cluster](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Origin-Agent-Cluster)                                         | ?1                                                                         | True       |
| referrerPolicy                  | [Referrer-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy)                                                   | no-referrer                                                                | True       |
| reportingEndpoints              | [Reporting-Endpoints](https://www.w3.org/TR/reporting-1/#header)                                                                               | Usage: [Setting Content-Security-Policy](#setting-content-security-policy) | No Setting |
| reportTo                        | [Report-To](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/report-to)                                       | Usage: [Setting Content-Security-Policy](#setting-content-security-policy) | No Setting |
| strictTransportSecurity         | [Strict-Transport-Security](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security)                               | max-age=15552000; includeSubDomains                                        | True       |
| xContentTypeOptions             | [X-Content-Type-Options](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Content-Type-Options)                                     | nosniff                                                                    | True       |
| xDnsPrefetchControl             | [X-DNS-Prefetch-Control](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-DNS-Prefetch-Control)                                     | off                                                                        | True       |
| xDownloadOptions                | [X-Download-Options](https://learn.microsoft.com/en-us/archive/blogs/ie/ie8-security-part-v-comprehensive-protection#mime-handling-force-save) | noopen                                                                     | True       |
| xFrameOptions                   | [X-Frame-Options](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options)                                                   | SAMEORIGIN                                                                 | True       |
| xPermittedCrossDomainPolicies   | [X-Permitted-Cross-Domain-Policies](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Permitted-Cross-Domain-Policies)               | none                                                                       | True       |
| xXssProtection                  | [X-XSS-Protection](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-XSS-Protection)                                                 | 0                                                                          | True       |
| permissionPolicy                | [Permissions-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Permissions-Policy)                                             | Usage: [Setting Permission-Policy](#setting-permission-policy)             | No Setting |

## Middleware Conflict

Please be cautious about the order of specification when dealing with middleware that manipulates the same header.

In this case, Secure-headers operates and the `x-powered-by` is removed:

In this case, Powered-By operates and the `x-powered-by` is added:

## Setting Content-Security-Policy

### `nonce` attribute

You can add a [`nonce` attribute](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/nonce) to a `script` or `style` element by adding the `NONCE` imported from `hono/secure-headers` to a `scriptSrc` or `styleSrc`:

If you want to generate the nonce value yourself, you can also specify a function as the following:

## Setting Permission-Policy

The Permission-Policy header allows you to control which features and APIs can be used in the browser. Here's an example of how to set it:

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { secureHeaders } from 'hono/secure-headers'
```

Example 2 (ts):
```ts
const app = new Hono()
app.use(secureHeaders())
```

Example 3 (ts):
```ts
const app = new Hono()
app.use(
  '*',
  secureHeaders({
    xFrameOptions: false,
    xXssProtection: false,
  })
)
```

Example 4 (ts):
```ts
const app = new Hono()
app.use(
  '*',
  secureHeaders({
    strictTransportSecurity:
      'max-age=63072000; includeSubDomains; preload',
    xFrameOptions: 'DENY',
    xXssProtection: '1',
  })
)
```

---

## Server-Timing Middleware

**URL:** llms-txt#server-timing-middleware

**Contents:**
- Import
- Usage
  - Conditionally enabled
- Result
- Options
  - <Badge type="info" text="optional" /> total: `boolean`
  - <Badge type="info" text="optional" /> enabled: `boolean` | `(c: Context) => boolean`
  - <Badge type="info" text="optional" /> totalDescription: `boolean`
  - <Badge type="info" text="optional" /> autoEnd: `boolean`
  - <Badge type="info" text="optional" /> crossOrigin: `boolean` | `string` | `(c: Context) => boolean | string`

The [Server-Timing](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Server-Timing) Middleware provides
performance metrics in the response headers.

::: info
Note: On Cloudflare Workers, the timer metrics may not be accurate,
since [timers only show the time of last I/O](https://developers.cloudflare.com/workers/learning/security-model/#step-1-disallow-timers-and-multi-threading).
:::

### Conditionally enabled

![](/images/timing-example.png)

### <Badge type="info" text="optional" /> total: `boolean`

Show the total response time. The default is `true`.

### <Badge type="info" text="optional" /> enabled: `boolean` | `(c: Context) => boolean`

Whether timings should be added to the headers or not. The default is `true`.

### <Badge type="info" text="optional" /> totalDescription: `boolean`

Description for the total response time. The default is `Total Response Time`.

### <Badge type="info" text="optional" /> autoEnd: `boolean`

If `startTime()` should end automatically at the end of the request.
If disabled, not manually ended timers will not be shown.

### <Badge type="info" text="optional" /> crossOrigin: `boolean` | `string` | `(c: Context) => boolean | string`

The origin this timings header should be readable.

- If false, only from current origin.
- If true, from all origin.
- If string, from this domain(s). Multiple domains must be separated with a comma.

The default is `false`. See more [docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Timing-Allow-Origin).

**Examples:**

Example 1 (unknown):
```unknown
## Usage
```

Example 2 (unknown):
```unknown
### Conditionally enabled
```

---

## Service Worker

**URL:** llms-txt#service-worker

**Contents:**
- 1. Setup
- 2. Hello World
  - Using `fire()`
- 3. Run

[Service Worker](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API) is a script that runs in the background of the browser to handle tasks like caching and push notifications. Using a Service Worker adapter, you can run applications made with Hono as [FetchEvent](https://developer.mozilla.org/en-US/docs/Web/API/FetchEvent) handler within the browser.

This page shows an example of creating a project using [Vite](https://vitejs.dev/).

First, create and move to your project directory:

Create the necessary files for the project. Make a `package.json` file with the following:

Similarly, create a `tsconfig.json` file with the following:

Next, install the necessary modules.

`main.ts` is a script to register the Service Worker:

In `sw.ts`, create an application using Hono and register it to the `fetch` event with the Service Worker adapter’s `handle` function. This allows the Hono application to intercept access to `/sw`.

The `fire()` function automatically calls `addEventListener('fetch', handle(app))` for you, making the code more concise.

Start the development server.

By default, the development server will run on port `5173`. Access `http://localhost:5173/` in your browser to complete the Service Worker registration. Then, access `/sw` to see the response from the Hono application.

**Examples:**

Example 1 (sh):
```sh
mkdir my-app
cd my-app
```

Example 2 (json):
```json
{
  "name": "my-app",
  "private": true,
  "scripts": {
    "dev": "vite dev"
  },
  "type": "module"
}
```

Example 3 (json):
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "lib": ["ES2020", "DOM", "WebWorker"],
    "moduleResolution": "bundler"
  },
  "include": ["./"],
  "exclude": ["node_modules"]
}
```

Example 4 (unknown):
```unknown

```

---

## SSG Helper

**URL:** llms-txt#ssg-helper

**Contents:**
- Usage
  - Manual
  - Vite Plugin
- toSSG
  - Input
  - Using adapters for Deno and Bun
  - Options
  - Output
- Generate File
  - Route and Filename

SSG Helper generates a static site from your Hono application. It will retrieve the contents of registered routes and save them as static files.

If you have a simple Hono application like the following:

For Node.js, create a build script like this:

By executing the script, the files will be output as follows:

Using the `@hono/vite-ssg` Vite Plugin, you can easily handle the process.

For more details, see here:

https://github.com/honojs/vite-plugins/tree/main/packages/ssg

`toSSG` is the main function for generating static sites, taking an application and a filesystem module as arguments. It is based on the following:

The arguments for toSSG are specified in ToSSGInterface.

- `app` specifies `new Hono()` with registered routes.
- `fs` specifies the following object, assuming `node:fs/promise`.

### Using adapters for Deno and Bun

If you want to use SSG on Deno or Bun, a `toSSG` function is provided for each file system.

Options are specified in the ToSSGOptions interface.

- `dir` is the output destination for Static files. The default value is `./static`.
- `concurrency` is the concurrent number of files to be generated at the same time. The default value is `2`.
- `extensionMap` is a map containing the `Content-Type` as a key and the string of the extension as a value. This is used to determine the file extension of the output file.
- `plugins` is an array of SSG plugins that extend the functionality of the static site generation process.

`toSSG` returns the result in the following Result type.

### Route and Filename

The following rules apply to the registered route information and the generated file name. The default `./static` behaves as follows:

- `/` -> `./static/index.html`
- `/path` -> `./static/path.html`
- `/path/` -> `./static/path/index.html`

The file extension depends on the `Content-Type` returned by each route. For example, responses from `c.html` are saved as `.html`.

If you want to customize the file extensions, set the `extensionMap` option.

Note that paths ending with a slash are saved as index.ext regardless of the extension.

Introducing built-in middleware that supports SSG.

You can use an API like `generateStaticParams` of Next.js.

Routes with the `disableSSG` middleware set are excluded from static file generation by `toSSG`.

Routes with the `onlySSG` middleware set will be overridden by `c.notFound()` after `toSSG` execution.

Plugins allow you to extend the functionality of the static site generation process. They use hooks to customize the generation process at different stages.

By default, `toSSG` uses `defaultPlugin` which skips non-200 status responses (like redirects, errors, or 404s). This prevents generating files for unsuccessful responses.

If you specify custom plugins, `defaultPlugin` is **not** automatically included. To keep the default behavior while adding custom plugins, explicitly include it:

Plugins can use the following hooks to customize the `toSSG` process:

- **BeforeRequestHook**: Called before processing each request. Return `false` to skip the route.
- **AfterResponseHook**: Called after receiving each response. Return `false` to skip file generation.
- **AfterGenerateHook**: Called after the entire generation process completes.

### Basic Plugin Examples

Filter only GET requests:

Filter by status code:

### Advanced Plugin Example

Here's an example of creating a sitemap plugin that generates a `sitemap.xml` file:

**Examples:**

Example 1 (tsx):
```tsx
// index.tsx
const app = new Hono()

app.get('/', (c) => c.html('Hello, World!'))
app.use('/about', async (c, next) => {
  c.setRenderer((content, head) => {
    return c.html(
      <html>
        <head>
          <title>{head.title ?? ''}</title>
        </head>
        <body>
          <p>{content}</p>
        </body>
      </html>
    )
  })
  await next()
})
app.get('/about', (c) => {
  return c.render('Hello!', { title: 'Hono SSG Page' })
})

export default app
```

Example 2 (ts):
```ts
// build.ts
import app from './index'
import { toSSG } from 'hono/ssg'
import fs from 'fs/promises'

toSSG(app, fs)
```

Example 3 (bash):
```bash
ls ./static
about.html  index.html
```

Example 4 (ts):
```ts
export interface ToSSGInterface {
  (
    app: Hono,
    fsModule: FileSystemModule,
    options?: ToSSGOptions
  ): Promise<ToSSGResult>
}
```

---

## Start of Hono documentation

**URL:** llms-txt#start-of-hono-documentation

---

## Streaming Helper

**URL:** llms-txt#streaming-helper

**Contents:**
- Import
- `stream()`
- `streamText()`
- `streamSSE()`
- Error Handling

The Streaming Helper provides methods for streaming responses.

It returns a simple streaming response as `Response` object.

It returns a streaming response with `Content-Type:text/plain`, `Transfer-Encoding:chunked`, and `X-Content-Type-Options:nosniff` headers.

If you are developing an application for Cloudflare Workers, a streaming may not work well on Wrangler. If so, add `Identity` for `Content-Encoding` header.

It allows you to stream Server-Sent Events (SSE) seamlessly.

The third argument of the streaming helper is an error handler.
This argument is optional, if you don't specify it, the error will be output as a console error.

The stream will be automatically closed after the callbacks are executed.

If the callback function of the streaming helper throws an error, the `onError` event of Hono will not be triggered.

`onError` is a hook to handle errors before the response is sent and overwrite the response. However, when the callback function is executed, the stream has already started, so it cannot be overwritten.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { stream, streamText, streamSSE } from 'hono/streaming'
```

Example 2 (ts):
```ts
app.get('/stream', (c) => {
  return stream(c, async (stream) => {
    // Write a process to be executed when aborted.
    stream.onAbort(() => {
      console.log('Aborted!')
    })
    // Write a Uint8Array.
    await stream.write(new Uint8Array([0x48, 0x65, 0x6c, 0x6c, 0x6f]))
    // Pipe a readable stream.
    await stream.pipe(anotherReadableStream)
  })
})
```

Example 3 (ts):
```ts
app.get('/streamText', (c) => {
  return streamText(c, async (stream) => {
    // Write a text with a new line ('\n').
    await stream.writeln('Hello')
    // Wait 1 second.
    await stream.sleep(1000)
    // Write a text without a new line.
    await stream.write(`Hono!`)
  })
})
```

Example 4 (ts):
```ts
app.get('/streamText', (c) => {
  c.header('Content-Encoding', 'Identity')
  return streamText(c, async (stream) => {
    // ...
  })
})
```

---

## Supabase Edge Functions

**URL:** llms-txt#supabase-edge-functions

**Contents:**
- 1. Setup
  - Prerequisites
  - Creating a New Project
  - Adding an Edge Function
- 2. Hello World
- 3. Run
- 4. Deploy

[Supabase](https://supabase.com/) is an open-source alternative to Firebase, offering a suite of tools similar to Firebase's capabilities, including database, authentication, storage, and now, serverless functions.

Supabase Edge Functions are server-side TypeScript functions that are distributed globally, running closer to your users for improved performance. These functions are developed using [Deno](https://deno.com/), which brings several benefits, including improved security and a modern JavaScript/TypeScript runtime.

Here's how you can get started with Supabase Edge Functions:

Before you begin, make sure you have the Supabase CLI installed. If you haven't installed it yet, follow the instructions in the [official documentation](https://supabase.com/docs/guides/cli/getting-started).

### Creating a New Project

1. Open your terminal or command prompt.

2. Create a new Supabase project in a directory on your local machine by running:

This command initializes a new Supabase project in the current directory.

### Adding an Edge Function

3. Inside your Supabase project, create a new Edge Function named `hello-world`:

This command creates a new Edge Function with the specified name in your project.

Edit the `hello-world` function by modifying the file `supabase/functions/hello-world/index.ts`:

To run the function locally, use the following command:

1. Use the following command to serve the function:

The `--no-verify-jwt` flag allows you to bypass JWT verification during local development.

2. Make a GET request using cURL or Postman to `http://127.0.0.1:54321/functions/v1/hello-world/hello`:

This request should return the text "Hello from hono-server!".

You can deploy all of your Edge Functions in Supabase with a single command:

Alternatively, you can deploy individual Edge Functions by specifying the name of the function in the deploy command:

For more deployment methods, visit the Supabase documentation on [Deploying to Production](https://supabase.com/docs/guides/functions/deploy).

**Examples:**

Example 1 (bash):
```bash
supabase init
```

Example 2 (bash):
```bash
supabase functions new hello-world
```

Example 3 (ts):
```ts
import { Hono } from 'jsr:@hono/hono'

// change this to your function name
const functionName = 'hello-world'
const app = new Hono().basePath(`/${functionName}`)

app.get('/hello', (c) => c.text('Hello from hono-server!'))

Deno.serve(app.fetch)
```

Example 4 (bash):
```bash
supabase start # start the supabase stack
supabase functions serve --no-verify-jwt # start the Functions watcher
```

---

## <SYSTEM>This is the full developer documentation for Hono.</SYSTEM>

**URL:** llms-txt#<system>this-is-the-full-developer-documentation-for-hono.</system>

---

## Testing

**URL:** llms-txt#testing

**Contents:**
- Request and Response
- Env

[Vitest]: https://vitest.dev/

Testing is important.
In actuality, it is easy to test Hono's applications.
The way to create a test environment differs from each runtime, but the basic steps are the same.
In this section, let's test with Cloudflare Workers and [Vitest].

::: tip
Cloudflare recommends using [Vitest] with [@cloudflare/vitest-pool-workers](https://www.npmjs.com/package/@cloudflare/vitest-pool-workers). For more details, please refer to [Vitest integration](https://developers.cloudflare.com/workers/testing/vitest-integration/) in the Cloudflare Workers docs.
:::

## Request and Response

All you do is create a Request and pass it to the Hono application to validate the Response.
And, you can use `app.request` the useful method.

::: tip
For a typed test client see the [testing helper](/docs/helpers/testing).
:::

For example, consider an application that provides the following REST API.

Make a request to `GET /posts` and test the response.

To make a request to `POST /posts`, do the following.

To make a request to `POST /posts` with `JSON` data, do the following.

To make a request to `POST /posts` with `multipart/form-data` data, do the following.

You can also pass an instance of the Request class.

In this way, you can test it as like an End-to-End.

To set `c.env` for testing, you can pass it as the 3rd parameter to `app.request`. This is useful for mocking values like [Cloudflare Workers Bindings](https://hono.dev/getting-started/cloudflare-workers#bindings):

**Examples:**

Example 1 (ts):
```ts
app.get('/posts', (c) => {
  return c.text('Many posts')
})

app.post('/posts', (c) => {
  return c.json(
    {
      message: 'Created',
    },
    201,
    {
      'X-Custom': 'Thank you',
    }
  )
})
```

Example 2 (ts):
```ts
describe('Example', () => {
  test('GET /posts', async () => {
    const res = await app.request('/posts')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('Many posts')
  })
})
```

Example 3 (ts):
```ts
test('POST /posts', async () => {
  const res = await app.request('/posts', {
    method: 'POST',
  })
  expect(res.status).toBe(201)
  expect(res.headers.get('X-Custom')).toBe('Thank you')
  expect(await res.json()).toEqual({
    message: 'Created',
  })
})
```

Example 4 (ts):
```ts
test('POST /posts', async () => {
  const res = await app.request('/posts', {
    method: 'POST',
    body: JSON.stringify({ message: 'hello hono' }),
    headers: new Headers({ 'Content-Type': 'application/json' }),
  })
  expect(res.status).toBe(201)
  expect(res.headers.get('X-Custom')).toBe('Thank you')
  expect(await res.json()).toEqual({
    message: 'Created',
  })
})
```

---

## Testing Helper

**URL:** llms-txt#testing-helper

**Contents:**
- Import
- `testClient()`

The Testing Helper provides functions to make testing of Hono applications easier.

The `testClient()` function takes an instance of Hono as its first argument and returns an object typed according to your Hono application's routes, similar to the [Hono Client](/docs/guides/rpc#client). This allows you to call your defined routes in a type-safe manner with editor autocompletion within your tests.

**Important Note on Type Inference:**

For the `testClient` to correctly infer the types of your routes and provide autocompletion, **you must define your routes using chained methods directly on the `Hono` instance**.

The type inference relies on the type flowing through the chained `.get()`, `.post()`, etc., calls. If you define routes separately after creating the Hono instance (like the common pattern shown in the "Hello World" example: `const app = new Hono(); app.get(...)`), the `testClient` will not have the necessary type information for specific routes, and you won't get the type-safe client features.

This example works because the `.get()` method is chained directly onto the `new Hono()` call:

To include headers in your test, pass them as the second parameter in the call. The second parameter can also take an `init` property as a `RequestInit` object, allowing you to set headers, method, body, etc. Learn more about the `init` property [here](/docs/guides/rpc#init-option).

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { testClient } from 'hono/testing'
```

Example 2 (ts):
```ts
// index.ts
const app = new Hono().get('/search', (c) => {
  const query = c.req.query('q')
  return c.json({ query: query, results: ['result1', 'result2'] })
})

export default app
```

Example 3 (ts):
```ts
// index.test.ts
import { Hono } from 'hono'
import { testClient } from 'hono/testing'
import { describe, it, expect } from 'vitest' // Or your preferred test runner
import app from './app'

describe('Search Endpoint', () => {
  // Create the test client from the app instance
  const client = testClient(app)

  it('should return search results', async () => {
    // Call the endpoint using the typed client
    // Notice the type safety for query parameters (if defined in the route)
    // and the direct access via .$get()
    const res = await client.search.$get({
      query: { q: 'hono' },
    })

    // Assertions
    expect(res.status).toBe(200)
    expect(await res.json()).toEqual({
      query: 'hono',
      results: ['result1', 'result2'],
    })
  })
})
```

Example 4 (ts):
```ts
// index.test.ts
import { Hono } from 'hono'
import { testClient } from 'hono/testing'
import { describe, it, expect } from 'vitest' // Or your preferred test runner
import app from './app'

describe('Search Endpoint', () => {
  // Create the test client from the app instance
  const client = testClient(app)

  it('should return search results', async () => {
    // Include the token in the headers and set the content type
    const token = 'this-is-a-very-clean-token'
    const res = await client.search.$get(
      {
        query: { q: 'hono' },
      },
      {
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': `application/json`,
        },
      }
    )

    // Assertions
    expect(res.status).toBe(200)
    expect(await res.json()).toEqual({
      query: 'hono',
      results: ['result1', 'result2'],
    })
  })
})
```

---

## Third-party Middleware

**URL:** llms-txt#third-party-middleware

**Contents:**
  - Authentication
  - Validators
  - OpenAPI
  - Others

Third-party middleware refers to middleware not bundled within the Hono package.
Most of this middleware leverages external libraries.

- [Auth.js(Next Auth)](https://github.com/honojs/middleware/tree/main/packages/auth-js)
- [Clerk Auth](https://github.com/honojs/middleware/tree/main/packages/clerk-auth)
- [OAuth Providers](https://github.com/honojs/middleware/tree/main/packages/oauth-providers)
- [OIDC Auth](https://github.com/honojs/middleware/tree/main/packages/oidc-auth)
- [Firebase Auth](https://github.com/honojs/middleware/tree/main/packages/firebase-auth)
- [Verify RSA JWT (JWKS)](https://github.com/wataruoguchi/verify-rsa-jwt-cloudflare-worker)
- [Stytch Auth](https://github.com/honojs/middleware/tree/main/packages/stytch-auth)

- [ArkType validator](https://github.com/honojs/middleware/tree/main/packages/arktype-validator)
- [Effect Schema Validator](https://github.com/honojs/middleware/tree/main/packages/effect-validator)
- [Standard Schema Validator](https://github.com/honojs/middleware/tree/main/packages/standard-validator)
- [TypeBox Validator](https://github.com/honojs/middleware/tree/main/packages/typebox-validator)
- [Typia Validator](https://github.com/honojs/middleware/tree/main/packages/typia-validator)
- [unknownutil Validator](https://github.com/ryoppippi/hono-unknownutil-validator)
- [Valibot Validator](https://github.com/honojs/middleware/tree/main/packages/valibot-validator)
- [Zod Validator](https://github.com/honojs/middleware/tree/main/packages/zod-validator)

- [Zod OpenAPI](https://github.com/honojs/middleware/tree/main/packages/zod-openapi)
- [Scalar](https://github.com/scalar/scalar/tree/main/integrations/hono)
- [Swagger UI](https://github.com/honojs/middleware/tree/main/packages/swagger-ui)
- [Hono OpenAPI](https://github.com/rhinobase/hono-openapi)
- [hono-zod-openapi](https://github.com/paolostyle/hono-zod-openapi)

- [Bun Transpiler](https://github.com/honojs/middleware/tree/main/packages/bun-transpiler)
- [esbuild Transpiler](https://github.com/honojs/middleware/tree/main/packages/esbuild-transpiler)
- [Event Emitter](https://github.com/honojs/middleware/tree/main/packages/event-emitter)
- [GraphQL Server](https://github.com/honojs/middleware/tree/main/packages/graphql-server)
- [Hono Rate Limiter](https://github.com/rhinobase/hono-rate-limiter)
- [Node WebSocket Helper](https://github.com/honojs/middleware/tree/main/packages/node-ws)
- [Prometheus Metrics](https://github.com/honojs/middleware/tree/main/packages/prometheus)
- [OpenTelemetry](https://github.com/honojs/middleware/tree/main/packages/otel)
- [Qwik City](https://github.com/honojs/middleware/tree/main/packages/qwik-city)
- [React Compatibility](https://github.com/honojs/middleware/tree/main/packages/react-compat)
- [React Renderer](https://github.com/honojs/middleware/tree/main/packages/react-renderer)
- [RONIN (Database)](https://github.com/ronin-co/hono-client)
- [Sentry](https://github.com/honojs/middleware/tree/main/packages/sentry)
- [tRPC Server](https://github.com/honojs/middleware/tree/main/packages/trpc-server)
- [Geo](https://github.com/ktkongtong/hono-geo-middleware/tree/main/packages/middleware)
- [Hono Simple DI](https://github.com/maou-shonen/hono-simple-DI)
- [Highlight.io](https://www.highlight.io/docs/getting-started/backend-sdk/js/hono)
- [Apitally (API monitoring & analytics)](https://docs.apitally.io/frameworks/hono)
- [Cap Checkpoint](https://capjs.js.org/guide/middleware/hono.html)

---

## Timeout Middleware

**URL:** llms-txt#timeout-middleware

**Contents:**
- Import
- Usage
- Notes
- Middleware Conflicts

The Timeout Middleware enables you to easily manage request timeouts in your application. It allows you to set a maximum duration for requests and optionally define custom error responses if the specified timeout is exceeded.

Here's how to use the Timeout Middleware with both default and custom settings:

- The duration for the timeout can be specified in milliseconds. The middleware will automatically reject the promise and potentially throw an error if the specified duration is exceeded.

- The timeout middleware cannot be used with stream Thus, use `stream.close` and `setTimeout` together.

## Middleware Conflicts

Be cautious about the order of middleware, especially when using error-handling or other timing-related middleware, as it might affect the behavior of this timeout middleware.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import { timeout } from 'hono/timeout'
```

Example 2 (ts):
```ts
const app = new Hono()

// Applying a 5-second timeout
app.use('/api', timeout(5000))

// Handling a route
app.get('/api/data', async (c) => {
  // Your route handler logic
  return c.json({ data: 'Your data here' })
})
```

Example 3 (ts):
```ts
import { HTTPException } from 'hono/http-exception'

// Custom exception factory function
const customTimeoutException = (context) =>
  new HTTPException(408, {
    message: `Request timeout after waiting ${context.req.headers.get(
      'Duration'
    )} seconds. Please try again later.`,
  })

// for Static Exception Message
// const customTimeoutException = new HTTPException(408, {
//   message: 'Operation timed out. Please try again later.'
// });

// Applying a 1-minute timeout with a custom exception
app.use('/api/long-process', timeout(60000, customTimeoutException))

app.get('/api/long-process', async (c) => {
  // Simulate a long process
  await new Promise((resolve) => setTimeout(resolve, 61000))
  return c.json({ data: 'This usually takes longer' })
})
```

Example 4 (ts):
```ts
app.get('/sse', async (c) => {
  let id = 0
  let running = true
  let timer: number | undefined

  return streamSSE(c, async (stream) => {
    timer = setTimeout(() => {
      console.log('Stream timeout reached, closing stream')
      stream.close()
    }, 3000) as unknown as number

    stream.onAbort(async () => {
      console.log('Client closed connection')
      running = false
      clearTimeout(timer)
    })

    while (running) {
      const message = `It is ${new Date().toISOString()}`
      await stream.writeSSE({
        data: message,
        event: 'time-update',
        id: String(id++),
      })
      await stream.sleep(1000)
    }
  })
})
```

---

## Trailing Slash Middleware

**URL:** llms-txt#trailing-slash-middleware

**Contents:**
- Import
- Usage
- Note

This middleware handles Trailing Slash in the URL on a GET request.

`appendTrailingSlash` redirects the URL to which it added the Trailing Slash if the content was not found. Also, `trimTrailingSlash` will remove the Trailing Slash.

Example of redirecting a GET request of `/about/me` to `/about/me/`.

Example of redirecting a GET request of `/about/me/` to `/about/me`.

It will be enabled when the request method is `GET` and the response status is `404`.

**Examples:**

Example 1 (ts):
```ts
import { Hono } from 'hono'
import {
  appendTrailingSlash,
  trimTrailingSlash,
} from 'hono/trailing-slash'
```

Example 2 (ts):
```ts
import { Hono } from 'hono'
import { appendTrailingSlash } from 'hono/trailing-slash'

const app = new Hono({ strict: true })

app.use(appendTrailingSlash())
app.get('/about/me/', (c) => c.text('With Trailing Slash'))
```

Example 3 (ts):
```ts
import { Hono } from 'hono'
import { trimTrailingSlash } from 'hono/trailing-slash'

const app = new Hono({ strict: true })

app.use(trimTrailingSlash())
app.get('/about/me', (c) => c.text('Without Trailing Slash'))
```

---

## Validation

**URL:** llms-txt#validation

**Contents:**
- Manual validator
- Multiple validators
- With Zod
- Zod Validator Middleware
- Standard Schema Validator Middleware
  - With Zod
  - With Valibot
  - With ArkType

Hono provides only a very thin Validator.
But, it can be powerful when combined with a third-party Validator.
In addition, the RPC feature allows you to share API specifications with your clients through types.

First, introduce a way to validate incoming values without using the third-party Validator.

Import `validator` from `hono/validator`.

To validate form data, specify `form` as the first argument and a callback as the second argument.
In the callback, validates the value and return the validated values at the end.
The `validator` can be used as middleware.

Within the handler you can get the validated value with `c.req.valid('form')`.

Validation targets include `json`, `query`, `header`, `param` and `cookie` in addition to `form`.

::: warning
When you validate `json` or `form`, the request _must_ contain a matching `content-type` header (e.g. `Content-Type: application/json` for `json`). Otherwise, the request body will not be parsed and you will receive an empty object (`{}`) as value in the callback.

It is important to set the `content-type` header when testing using
[`app.request()`](../api/request.md).

Given an application like this.

Your tests can be written like this.

::: warning
When you validate `header`, you need to use **lowercase** name as the key.

If you want to validate the `Idempotency-Key` header, you need to use `idempotency-key` as the key.

## Multiple validators

You can also include multiple validators to validate different parts of request:

You can use [Zod](https://zod.dev), one of third-party validators.
We recommend using a third-party validator.

Install from the Npm registry.

Import `z` from `zod`.

You can use the schema in the callback function for validation and return the validated value.

## Zod Validator Middleware

You can use the [Zod Validator Middleware](https://github.com/honojs/middleware/tree/main/packages/zod-validator) to make it even easier.

And import `zValidator`.

And write as follows.

## Standard Schema Validator Middleware

[Standard Schema](https://standardschema.dev/) is a specification that provides a common interface for TypeScript validation libraries. It was created by the maintainers of Zod, Valibot, and ArkType to allow ecosystem tools to work with any validation library without needing custom adapters.

The [Standard Schema Validator Middleware](https://github.com/honojs/middleware/tree/main/packages/standard-validator) lets you use any Standard Schema-compatible validation library with Hono, giving you the flexibility to choose your preferred validator while maintaining consistent type safety.

Import `sValidator` from the package:

You can use Zod with the Standard Schema validator:

[Valibot](https://valibot.dev/) is a lightweight alternative to Zod with a modular design:

[ArkType](https://arktype.io/) offers TypeScript-native syntax for runtime validation:

**Examples:**

Example 1 (ts):
```ts
import { validator } from 'hono/validator'
```

Example 2 (ts):
```ts
app.post(
  '/posts',
  validator('form', (value, c) => {
    const body = value['body']
    if (!body || typeof body !== 'string') {
      return c.text('Invalid!', 400)
    }
    return {
      body: body,
    }
  }),
  //...
```

Example 3 (ts):
```ts
, (c) => {
  const { body } = c.req.valid('form')
  // ... do something
  return c.json(
    {
      message: 'Created!',
    },
    201
  )
}
```

Example 4 (ts):
```ts
const app = new Hono()
app.post(
  '/testing',
  validator('json', (value, c) => {
    // pass-through validator
    return value
  }),
  (c) => {
    const body = c.req.valid('json')
    return c.json(body)
  }
)
```

---

## Vercel

**URL:** llms-txt#vercel

**Contents:**
- 1. Setup
- 2. Hello World
- 3. Run
- 4. Deploy
- Further reading

Vercel is the AI cloud, providing the developer tools and cloud infrastructure to build, scale, and secure a faster, more personalized web.

Hono can be deployed to Vercel with zero-configuration.

A starter for Vercel is available.
Start your project with "create-hono" command.
Select `vercel` template for this example.

Move into `my-app` and install the dependencies.

We will use Vercel CLI to work on the app locally in the next step. If you haven't already, install it globally following [the Vercel CLI documentation](https://vercel.com/docs/cli).

In the `index.ts` or `src/index.ts` of your project, export the Hono application as a default export.

If you started with the `vercel` template, this is already set up for you.

To run the development server locally:

Visiting `localhost:3000` will respond with a text response.

Deploy to Vercel using `vc deploy`.

[Learn more about Hono in the Vercel documentation](https://vercel.com/docs/frameworks/backend/hono).

**Examples:**

Example 1 (unknown):
```unknown

```

Example 2 (unknown):
```unknown

```

Example 3 (unknown):
```unknown

```

Example 4 (unknown):
```unknown

```

---

## Via cookie

**URL:** llms-txt#via-cookie

curl -H 'Cookie: language=ja' http://localhost:8787/

---

## Via header

**URL:** llms-txt#via-header

**Contents:**
- Default Configuration
- Key Behaviors
  - Detection Workflow
- Advanced Configuration
  - Custom Detection Order
  - Language Code Transformation
  - Cookie Configuration
  - Debugging
- Options Reference
  - Basic Options

curl -H 'Accept-Language: ar,en;q=0.9' http://localhost:8787/
ts
export const DEFAULT_OPTIONS: DetectorOptions = {
  order: ['querystring', 'cookie', 'header'],
  lookupQueryString: 'lang',
  lookupCookie: 'language',
  lookupFromHeaderKey: 'accept-language',
  lookupFromPathIndex: 0,
  caches: ['cookie'],
  ignoreCase: true,
  fallbackLanguage: 'en',
  supportedLanguages: ['en'],
  cookieOptions: {
    sameSite: 'Strict',
    secure: true,
    maxAge: 365 * 24 * 60 * 60,
    httpOnly: true,
  },
  debug: false,
}
ts
app.use(
  languageDetector({
    order: ['path', 'cookie', 'querystring', 'header'],
    lookupFromPathIndex: 0, // /en/profile → index 0 = 'en'
    supportedLanguages: ['en', 'ar'],
    fallbackLanguage: 'en',
  })
)
ts
app.use(
  languageDetector({
    convertDetectedLanguage: (lang) => lang.split('-')[0],
    supportedLanguages: ['en', 'ja'],
    fallbackLanguage: 'en',
  })
)
ts
app.use(
  languageDetector({
    lookupCookie: 'app_lang',
    caches: ['cookie'],
    cookieOptions: {
      path: '/', // Cookie path
      sameSite: 'Lax', // Cookie same-site policy
      secure: true, // Only send over HTTPS
      maxAge: 86400 * 365, // 1 year expiration
      httpOnly: true, // Not accessible via JavaScript
      domain: '.example.com', // Optional: specific domain
    },
  })
)
ts
languageDetector({
  caches: false,
})
ts
languageDetector({
  debug: true, // Shows: "Detected from querystring: ar"
})
ts
app.get('/:lang/home', (c) => {
  const lang = c.get('language') // 'en', 'ar', etc.
  return c.json({ message: getLocalizedContent(lang) })
})
ts
languageDetector({
  supportedLanguages: ['en', 'en-GB', 'ar', 'ar-EG'],
  convertDetectedLanguage: (lang) => lang.replace('_', '-'), // Normalize
})
```

**Examples:**

Example 1 (unknown):
```unknown
## Default Configuration
```

Example 2 (unknown):
```unknown
## Key Behaviors

### Detection Workflow

1. **Order**: Checks sources in this sequence by default:
   - Query parameter (?lang=ar)
   - Cookie (language=ar)
   - Accept-Language header

2. **Caching**: Stores detected language in a cookie (1 year by default)

3. **Fallback**: Uses `fallbackLanguage` if no valid detection (must be in `supportedLanguages`)

## Advanced Configuration

### Custom Detection Order

Prioritize URL path detection (e.g., /en/about):
```

Example 3 (unknown):
```unknown
### Language Code Transformation

Normalize complex codes (e.g., en-US → en):
```

Example 4 (unknown):
```unknown
### Cookie Configuration
```

---

## Via path

**URL:** llms-txt#via-path

curl http://localhost:8787/ar/home

---

## Via query parameter

**URL:** llms-txt#via-query-parameter

curl http://localhost:8787/?lang=ar

---

## WebSocket Helper

**URL:** llms-txt#websocket-helper

**Contents:**
- Import
- `upgradeWebSocket()`
- RPC-mode
- Examples
  - Server and Client
  - Bun with JSX

WebSocket Helper is a helper for server-side WebSockets in Hono applications.
Currently Cloudflare Workers / Pages, Deno, and Bun adapters are available.

If you use Node.js, you can use [@hono/node-ws](https://github.com/honojs/middleware/tree/main/packages/node-ws).

## `upgradeWebSocket()`

`upgradeWebSocket()` returns a handler for handling WebSocket.

- `onOpen` - Currently, Cloudflare Workers does not support it.
- `onMessage`
- `onClose`
- `onError`

If you use middleware that modifies headers (e.g., applying CORS) on a route that uses WebSocket Helper, you may encounter an error saying you can't modify immutable headers. This is because `upgradeWebSocket()` also changes headers internally.

Therefore, please be cautious if you are using WebSocket Helper and middleware at the same time.

Handlers defined with WebSocket Helper support RPC mode.

See the examples using WebSocket Helper.

### Server and Client

**Examples:**

Example 1 (unknown):
```unknown

```

Example 2 (unknown):
```unknown

```

Example 3 (unknown):
```unknown
:::

If you use Node.js, you can use [@hono/node-ws](https://github.com/honojs/middleware/tree/main/packages/node-ws).

## `upgradeWebSocket()`

`upgradeWebSocket()` returns a handler for handling WebSocket.
```

Example 4 (unknown):
```unknown
Available events:

- `onOpen` - Currently, Cloudflare Workers does not support it.
- `onMessage`
- `onClose`
- `onError`

::: warning

If you use middleware that modifies headers (e.g., applying CORS) on a route that uses WebSocket Helper, you may encounter an error saying you can't modify immutable headers. This is because `upgradeWebSocket()` also changes headers internally.

Therefore, please be cautious if you are using WebSocket Helper and middleware at the same time.

:::

## RPC-mode

Handlers defined with WebSocket Helper support RPC mode.
```

---

## Web Standards

**URL:** llms-txt#web-standards

Hono uses only **Web Standards** like Fetch.
They were originally used in the `fetch` function and consist of basic objects that handle HTTP requests and responses.
In addition to `Requests` and `Responses`, there are `URL`, `URLSearchParam`, `Headers` and others.

Cloudflare Workers, Deno, and Bun also build upon Web Standards.
For example, a server that returns "Hello World" could be written as below. This could run on Cloudflare Workers and Bun.

Hono uses only Web Standards, which means that Hono can run on any runtime that supports them.
In addition, we have a Node.js adapter. Hono runs on these runtimes:

- Cloudflare Workers (`workerd`)
- Deno
- Bun
- Fastly Compute
- AWS Lambda
- Node.js
- Vercel (edge-light)

It also works on Netlify and other platforms.
The same code runs on all platforms.

Cloudflare Workers, Deno, Shopify, and others launched [WinterCG](https://wintercg.org) to discuss the possibility of using the Web Standards to enable "web-interoperability".
Hono will follow their steps and go for **the Standard of the Web Standards**.

---

## wrangler.toml

**URL:** llms-txt#wrangler.toml

**Contents:**
- Infer
- Parsing a Response with type-safety helper
- Using SWR
- Using RPC with larger applications
- Known issues
  - IDE performance

services = [
  { binding = "AUTH", service = "auth-service" },
]
ts
// src/client.ts
const client = hc<CreateProfileType>('http://localhost', {
  fetch: c.env.AUTH.fetch.bind(c.env.AUTH),
})
ts
import type { InferRequestType, InferResponseType } from 'hono/client'

// InferRequestType
const $post = client.todo.$post
type ReqType = InferRequestType<typeof $post>['form']

// InferResponseType
type ResType = InferResponseType<typeof $post>
ts
import { parseResponse, DetailedError } from 'hono/client'

// result contains the parsed response body (automatically parsed based on Content-Type)
const result = await parseResponse(client.hello.$get()).catch(
  (e: DetailedError) => {
    console.error(e)
  }
)
// parseResponse automatically throws an error if response is not ok
tsx
import useSWR from 'swr'
import { hc } from 'hono/client'
import type { InferRequestType } from 'hono/client'
import type { AppType } from '../functions/api/[[route]]'

const App = () => {
  const client = hc<AppType>('/api')
  const $get = client.hello.$get

const fetcher =
    (arg: InferRequestType<typeof $get>) => async () => {
      const res = await $get(arg)
      return await res.json()
    }

const { data, error, isLoading } = useSWR(
    'api-hello',
    fetcher({
      query: {
        name: 'SWR',
      },
    })
  )

if (error) return <div>failed to load</div>
  if (isLoading) return <div>loading...</div>

return <h1>{data?.message}</h1>
}

export default App
ts
// authors.ts
import { Hono } from 'hono'

const app = new Hono()
  .get('/', (c) => c.json('list authors'))
  .post('/', (c) => c.json('create an author', 201))
  .get('/:id', (c) => c.json(`get ${c.req.param('id')}`))

export default app
ts
// books.ts
import { Hono } from 'hono'

const app = new Hono()
  .get('/', (c) => c.json('list books'))
  .post('/', (c) => c.json('create a book', 201))
  .get('/:id', (c) => c.json(`get ${c.req.param('id')}`))

export default app
ts
// index.ts
import { Hono } from 'hono'
import authors from './authors'
import books from './books'

const app = new Hono()

const routes = app.route('/authors', authors).route('/books', books)

export default app
export type AppType = typeof routes
ts
// app.ts
export const app = new Hono().get('foo/:id', (c) =>
  c.json({ ok: true }, 200)
)
ts
export const app = Hono<BlankEnv, BlankSchema, '/'>().get<
  'foo/:id',
  'foo/:id',
  JSONRespondReturn<{ ok: boolean }, 200>,
  BlankInput,
  BlankEnv
>('foo/:id', (c) => c.json({ ok: true }, 200))
ts
import { app } from './app'
import { hc } from 'hono/client'

// this is a trick to calculate the type when compiling
export type Client = ReturnType<typeof hc<typeof app>>

export const hcWithType = (...args: Parameters<typeof hc>): Client =>
  hc<typeof app>(...args)
ts
const client = hcWithType('http://localhost:8787/')
const res = await client.posts.$post({
  form: {
    title: 'Hello',
    body: 'Hono is a cool project',
  },
})
ts
const app = new Hono().get<'foo/:id'>('foo/:id', (c) =>
  c.json({ ok: true }, 200)
)
ts
// authors-cli.ts
import { app as authorsApp } from './authors'
import { hc } from 'hono/client'

const authorsClient = hc<typeof authorsApp>('/authors')

// books-cli.ts
import { app as booksApp } from './books'
import { hc } from 'hono/client'

const booksClient = hc<typeof booksApp>('/books')
```

This way, `tsserver` doesn't need to instantiate types for all routes at once.

**Examples:**

Example 1 (unknown):
```unknown

```

Example 2 (unknown):
```unknown
## Infer

Use `InferRequestType` and `InferResponseType` to know the type of object to be requested and the type of object to be returned.
```

Example 3 (unknown):
```unknown
## Parsing a Response with type-safety helper

You can use `parseResponse()` helper to easily parse a Response from `hc` with type-safety.
```

Example 4 (unknown):
```unknown
## Using SWR

You can also use a React Hook library such as [SWR](https://swr.vercel.app).
```

---

## "--template cloudflare-workers" selects the Cloudflare Workers template

**URL:** llms-txt#"--template-cloudflare-workers"-selects-the-cloudflare-workers-template

**Contents:**
- Commonly used arguments
- Example flows
  - Minimal, interactive
  - Non-interactive, pick template and package manager
  - Use offline cache (no network)
- Troubleshooting & tips
- Links & references

deno init --npm hono@latest my-app --template cloudflare-workers
bash
npm create hono@latest my-app
bash
npm create hono@latest my-app -- --template vercel --pm npm --install
bash
pnpm create hono@latest my-app --template deno --offline
```

## Troubleshooting & tips

- If an option appears not to be recognized, make sure you're forwarding it with `--` when using `npm create` / `npx` .
- To see the most current list of templates and flags, consult the `create-hono` repository or run the initializer locally and follow its help output.

## Links & references

- `create-hono` repository : [create-hono](https://github.com/honojs/create-hono)

**Examples:**

Example 1 (unknown):
```unknown
:::

## Commonly used arguments

| Argument                | Description                                                                                                                                      | Example                         |
| :---------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------ |
| `--template <template>` | Select a starter template and skip the interactive template prompt. Templates may include names like `bun`, `cloudflare-workers`, `vercel`, etc. | `--template cloudflare-workers` |
| `--install`             | Automatically install dependencies after the template is created.                                                                                | `--install`                     |
| `--pm <packageManager>` | Specify which package manager to run when installing dependencies. Common values: `npm`, `pnpm`, `yarn`.                                         | `--pm pnpm`                     |
| `--offline`             | Use the local cache/templates instead of fetching the latest remote templates. Useful for offline environments or deterministic local runs.      | `--offline`                     |

> [!NOTE]
> The exact set of templates and available options is maintained by the `create-hono` project. This docs page summarizes the most-used flags — see the linked repository below for the full, authoritative reference.

## Example flows

### Minimal, interactive
```

Example 2 (unknown):
```unknown
This prompts you for template and options.

### Non-interactive, pick template and package manager
```

Example 3 (unknown):
```unknown
This creates `my-app` using the `vercel` template, installs dependencies using `npm`, and skips the interactive prompts.

### Use offline cache (no network)
```

---
