# AI-Blog-Sandbox

A modern Rails blog application that automatically generates AI images for your blog posts using OpenAI's DALL-E API. Built with Ruby on Rails and styled with Tailwind CSS.

## Features

- Create, edit, and delete blog posts
- Automatic AI image generation based on prompts
- Modern, responsive UI using Tailwind CSS
- Real-time image generation status updates

## Requirements

- Ruby 3.x
- Rails 7.x
- Node.js & Yarn
- OpenAI API key

## Setup

1. Clone the repository
```bash
git clone https://github.com/sparklepop/AI-Blog-Sandbox.git
cd AI-Blog-Sandbox
```

2. Install dependencies
```bash
bundle install
yarn install
```

3. Set up your credentials
```bash
rails credentials:edit
```
Add your OpenAI API key:
```yaml
openai:
  access_key: your_api_key_here
```

4. Set up the database
```bash
rails db:create db:migrate
```

5. Start the server
```bash
bin/dev
```

Visit `http://localhost:3000` to see your blog!

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sparklepop/AI-Blog-Sandbox.

## License

This project is available as open source under the terms of the MIT License.
