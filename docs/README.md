
 [PT-BR](Readme.pt.md) | ENG-US

## Classroom Environment Provisioning Pipeline
> Infrastructure-as-Code (IaC) Solution for Windows-based Educational Environments.

---
### The Problem (Production Constraints)

In laboratory settings with frequent machine reformatting, the manual setup of development environments was a major bottleneck. Verifying and installing VS Code, Node.js, and Nodemon, while manually configuring PowerShell Execution Policies, consumed upwards of 30 to 60 minutes per session.

When scaled across an entire classroom, this "setup debt" often jeopardized the lesson plan and reduced actual teaching time by nearly 50%.

---

### The Solution

I engineered a lightweight, "one-click" automation pipeline using PowerShell and Batch to handle the entire environment lifecycle. This solution transforms a 30-minute manual process into a 2-minute automated deployment.

---

### Pipeline Architecture

- **Phase 1:** **Environment Validation:** Automated check for internet connectivity and DNS resolution.
  
- **Phase 2: Security Bypass:** Programmatic elevation of ExecutionPolicy (Process/User scope) to allow script execution without compromising permanent system security.
  
- **Phase 3: Smart Provisioning:**  Resilient installation of VS Code and Node.js via Winget.
  
    - Global installation of Nodemon via NPM.
    - Retry Logic: Implemented a 3-attempt failover system for unstable network conditions.
      
- **Phase 4: Workspace Orchestration:** Automated creation of dated project folders and synchronized launching of educational resources (Notion & Google Drive).


---


## Impact
- Setup Efficiency: Reduced environment provisioning time by over 90%.
  
- Reliability: Eliminated "configuration drift" by ensuring every student has an identical environment.
  
- Resilience: The script handles "already installed" states gracefully, preventing redundant downloads and errors.

---
  
### Documentation & Accessibility
*  Comments on code in Portuguese for Maintainability of project. 

* This ensures that local instructors, lab technicians, and students can easily understand, audit, and modify the logic, regardless of their English proficiency.

---

## Changelog

### v1.1.0
- **Code Documentation:** All scripts (`Launcher.bat`, `Main.ps1`, `Check-Environment.ps1`, `Install-Tools.ps1`, `Setup-Workspace.ps1`) received a full documentation pass.
- Inline comments rewritten for technical clarity, covering architectural decisions, non-obvious PowerShell behaviors, and maintainability rationale.
- All script comments written in Portuguese for local instructor and lab technician accessibility.
- **README:** Added Portuguese translation (`README.pt.md`) and changelog section.
### v1.0.0
- Initial release: automated provisioning pipeline for classroom environments.