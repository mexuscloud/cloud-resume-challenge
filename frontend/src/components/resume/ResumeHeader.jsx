import React from "react"; 
import { NavLink } from "react-router";

export default function ResumeHeader(props) {
  const person = props.person;
  const contact = props.person.contact; 

  return (
    <section className="header">
      <h1>{ person.name }</h1>  
      <p>
        <span className="address">{contact.address}</span>
        <span className="bull">&bull;</span>
        <span className="email"><a href="mailto:{contact.email}">contact.email</a></span>
        <span className="bull">&bull;</span> 
        <span className="phone">{contact.phone}</span>
      </p>
    </section>
  );
}
