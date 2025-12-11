import React from "react"; 
import 'css/pages/projects.css'
import projectsData from 'data/projectsData'
import { NavLink } from "react-router";
import { useParams } from "react-router";
import { ChevronLeft } from 'lucide-react';

export default function ProjectPage() {
  const { handle } = useParams();

  const project = projectsData.find(p => p.handle === handle); 
  return (
    <>
      <NavLink className="btn l-icon" to={`/projects`}>
        <ChevronLeft />
        Back To All Projects
      </NavLink>
      <h1 className="fancy">Project: {project.name}</h1>  
      <p>{project.description}</p>
      <div className="markdown" dangerouslySetInnerHTML={{__html: project.body_html}}/>
    </>
  )
}