import React from "react"; 
import 'css/pages/post.css'
import blogData from 'data/blogData'
import { NavLink } from "react-router";
import { useParams } from "react-router";
import { ChevronLeft } from 'lucide-react';

export default function PostPage() {
  const { handle, date } = useParams();

  const post = blogData.find(p => p.handle === handle); 
  return (
    <>  
      <h1 className="fancy">{post.name}</h1>
      <NavLink className="btn l-icon" to={`/`}>
        <ChevronLeft />
        Back To Home Page
      </NavLink>
      <div className="markdown" dangerouslySetInnerHTML={{__html: post.body_html}}/>
    </>
  )
}