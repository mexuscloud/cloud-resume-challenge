## Render Project Emulate Markdown 

For our project page we want to be able to render markdown. 
We know we should render markdown serverside because client side markdown rendering is difficult to implement and provides inconsistent results. 

our `render_projects.py` will render our json with the marldown into html. 
Eventually we'll rework this code into our serverless functions. 

## Render Items with Frontmatter 

Both my projects and blog post relay on markdown. 
It would probably be better to collect the markdown files with front matter and turn those into json objects. 
Everything contained within a directory for data. 

eg. `/projects/:handle.markdown` 

eg. `/blog/:handle.markdown` 

## Task Runner with Invoke 

I am using the task runner invoke and refactor the render_projects into render_items so it can render the projects and the blog. 

```sh
invoke --list 
invoke render-blog
invoke render-
```





