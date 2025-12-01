import React from "react"; 
import { NavLink } from "react-router";

export default function ResumeSectionItem(props) {
	const item = props.item;
    return (
		<div className="item">
			<div className="item_heading">
				<div className="info">
				<h3>{item.title}</h3>
				<p>{item.subtitle}</p>

				{Array.isArray(item.details) && item.details.length > 0 && (
					<ul>
						{item.details.map((detail, idx) => (
							<li key={idx}>{detail}</li>
						))}
					</ul>
				)}
			</div>
			<div className="details">
				<div>{item.location}</div>
				<div>{item.duration}</div>
			</div>
		</div>
	</div>
    );
}
