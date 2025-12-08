import React from "react"; 
import 'css/pages/projects.css'
import projectsData from 'data/projectsData'
import ProjectItem from 'comps/ProjectItem'

export default function ProjectsPage() {
  return (
    <>
      <h1 className="fancy">Yemane Nigusse's Projects</h1>
      <div className="projects">
        {projectsData.map((project) => (
          <ProjectItem key={project.handle} project={project} />
        ))}
      </div>
    </>
  )
}   