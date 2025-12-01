import React from "react"; 
import 'css/pages/resume.css'
import ResumeHeader from "comps/resume/ResumeHeader"
import ResumeSection from "comps/resume/ResumeSection"
import resumeData from "data/resumeData";

export default function ResumePage() {
  return (
    <>
      <ResumeHeader person={resumeData.person}></ResumeHeader>
      <ResumeSection title='Education' handle='education' section={resumeData.sections.education} />
      <ResumeSection title='Experience' handle='experience' section={resumeData.sections.experience} />
      <ResumeSection title='Leadership & Activities' handle='leadership' section={resumeData.sections.leadership} />
      <ResumeSection title='Skills & Interests' handle='skills_interests' section={resumeData.sections.skills_interests} />
    </>
  );
}