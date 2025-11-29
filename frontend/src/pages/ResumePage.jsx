import React from "react"; 

export default function ResumePage() {
  return (
    <>
      <section className="header">
        <h1>Yemane Nigusse</h1>
        <p>
            560 La Grange Dr. Fate, TX 75087 
            &bull;
            <a href="mailto:yemexx.tekile@gmail.com">yemexx.tekile@gmail.com</a>
            &bull; +1 469-835-5228
        </p>
      </section>

      <section className="education">
        <h2>Education</h2>
        <div className="items">
          <div className="item">
            <div className="item_heading">
              <div className="info">
                <h3>Bahir Dar University</h3>
                <p>Bachelor's degree in Mechanical Engineering</p>
              </div>
              <div className="details">
                <div className="location">Bahir Dar, ETH</div>
                <div className="duration">2009</div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section className="experience">
        <h2>Experience</h2>
        <div className="items">
          <div className="item">
            <div className="item_heading">
              <div className="info">
                <h3>Amdocs &mdash; Quality Assurance Test Engineer</h3>
                <p></p>
              </div>
              <div className="details">
                <div className="location">Chicago, IL</div>
                <div className="duration">2016 &mdash; Present</div>
              </div>
            </div>
            <ul>
              <li>Telecom CRM application testing</li>
              <li>Telecom CRM application testing</li>
              <li>Telecom CRM application testing</li>
            </ul>
          </div>
        </div>
      </section>

      <section className="leadership">
        <h2>Leadership &amp; Activities</h2>
        <div className="items">
          <div className="item">
            <div className="item_heading">
              <div className="info">
                <h3>Cloud Resume Challenge</h3>
                <p>Maintain the communicty project</p>
              </div>
              <div className="details">
                <div className="location">Online</div>
                <div className="duration">2025</div>
              </div>
            </div>
            <ul>
              <li>update eBooks</li>
              <li>update eBooks</li>
            </ul>
          </div>
        </div>
      </section>
      <section className="skills">
        <h2>Skills &amp; Interests</h2>
        <div className="items">

          <div className="item">
            <div className="item_heading">
              <div className="info">
                <h3>AWS Cloud Practioner Certification</h3>
                <p>Currently studying</p>
              </div>
              <div className="details">
                <div className="code">Online</div>
                <div className="duration">Valid Till:</div>
              </div>
            </div>
          </div>

          <div className="item">
            <div className="item_heading">
              <div className="info">
                <h3>GitHub Foundations Certification</h3>
                <p>
                  Foundational understanding of GitHub's products, concepts, and workflows
                  related to collaboration, contribution, and project management.
                </p>
              </div>
              <div className="details">
                <div className="code">Online</div>
                <div className="duration">Valid Till:</div>
              </div>
            </div>
          </div>

          <div className="item">
            <div className="item_heading">
              <div className="info">
                <h3>Terraform Associate Certification</h3>
                <p>HashiCorp Certified: Terraform Associate (003)</p>
              </div>
              <div className="details">
                <div className="code">Online</div>
                <div className="duration">Valid Till:</div>
              </div>
            </div>
          </div>

          <div className="item">
            <div className="item_heading">
              <div className="info">
                <h3>The Cloud Bootcamp</h3>
                <p>MultiCloud Specialization Program</p>
              </div>
              <div className="details">
                <div className="code">Online</div>
                <div className="duration">Valid Till:</div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}