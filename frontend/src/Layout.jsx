import { useEffect, useState } from 'react'
import Header from 'comps/Header'
import ResumePage from 'pages/ResumePage'
import { Outlet, NavLink, useLocation } from 'react-router'; 
import 'css/default.css'
import 'css/pygments.css'
import 'css/markdown.css'

export default function Layout() {
  const location = useLocation(); 
  const path = location.pathname;

  let pageName = ''
  useEffect(() => {
    if (path === "/") {
      pageName = "home";

    } else if (path === "/resume") {
      pageName = "resume";

    } else if (path === "/projects") {
      pageName = "projects";

    // /blog/:date/:handle → e.g. /blog/2025-12-06/hello-world
    } else if (/^\/blog\/\d{4}-\d{2}-\d{2}\/[^/]+$/.test(path)) {
      pageName = "blog_post";

    // /project/:handle → e.g. /project/cruddur
    } else if (/^\/projects\/[^/]+$/.test(path)) {
      pageName = "project";
    }
    document.body.setAttribute("location", pageName); 
    return () => {
      document.body.removeAttribute("location"); 
    }; 
  }, [location]); 

  return (
    <>
      <Header></Header>
      <div className="content_wrap">
          <div className="content">
            <article>
            <Outlet />
            </article>
          </div> 
      </div> 
    </>
  )
}


