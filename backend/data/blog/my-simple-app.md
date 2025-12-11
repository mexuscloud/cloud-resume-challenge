---
name: My Simple Web App!
handle: my-simple-app
date: '2025-12-10'
---

# Simple Python Web Application

This project is a minimal web application built using Python.  
It was created to demonstrate how to structure a small web project, serve dynamic pages, and keep the codebase clean and maintainable.

The application uses:
- `Flask` for routing and server logic  
- `Jinja2` templates for HTML rendering  
- A clean project structure with separation of concerns  

---

## 📘 Background — How the App Was Created

I wanted a small, clear example of a Python web application that anyone could run.  
So I built a simple app where:

1. A user visits the home page (`/`)
2. The server responds with a rendered HTML template
3. The code stays lightweight but scalable

The main goals were:
- Keep it extremely simple
- Make the folder structure easy to understand
- Allow room for future expansion

This project is ideal for beginners learning Flask, or for anyone needing a compact reference project.

---

## 📁 Project Structure

Below is the full file structure, formatted as code:

```bash
simple-web-app/
├── app.py
├── requirements.txt
├── README.md
└── templates/
    └── index.html
```

### app.py 

```python
from flask import Flask, render_template

app = Flask(__name__)

@app.route("/")
def home():
    return render_template("index.html")

if __name__ == "__main__":
    app.run(debug=True)
```

### templates/index.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Simple Web App!</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background: #fafafa;
        }
        h1 {
            color: #333;
        }
        p {
            max-width: 600px;
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <h1>Welcome to My Simple Python Web App!</h1>
    <p>
        This page is rendered by Flask using a Jinja2 template.
        It's a minimal example designed to show how simple a Python web
        application can be.
    </p>
</body>
</html>
```

### requirements.txt

```text 
Flask==3.0.0
```

#### run the development server

```sh
python app.py
```

Then open: 

```http
http://127.0.0.1:5000/
```


