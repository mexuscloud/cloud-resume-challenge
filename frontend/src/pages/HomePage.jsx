import React from "react"; 
import 'css/pages/home.css'
import yemane_nigusse from 'images/yemane-nigusse-thumb.webp'
import blogData from 'data/blogData.json'
import PostItem from 'comps/PostItem'

export default function HomePage() {
  return (
    <>
      <h1 className="fancy">Yemane Nigusse's Blog</h1>
      <div className="intro_video">
        <img src={yemane_nigusse} />
      </div>
      
      <section className="posts">
        <h2>Recent Posts</h2>
        {blogData.map((post) => (
          <PostItem key={post.handle} post={post} />
        ))}
      </section>
    </>
  )
} 