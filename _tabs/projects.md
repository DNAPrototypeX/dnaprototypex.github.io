---
layout: page
icon: fas fa-cogs
order: 1
title: Projects
---
<style>
  /* Use !important to override Chirpy's internal 'page' layouts */
  #project-list .project-card {
    border: 1px solid var(--main-border-color, #ccc) !important;
    border-radius: 0.75rem !important;
    padding: 1.5rem !important;
    background-color: var(--card-bg) !important;
    margin-bottom: 1.5rem !important;
    display: flex !important;
    flex-direction: column !important;
    transition: none !important;
    box-shadow: none !important;
    transform: none !important;
  }

.badge-status {
    display: inline-flex !important;
    align-items: center !important;
    justify-content: center !important;
    width: 32px !important;
    height: 32px !important;
    border-radius: 50% !important;
    font-size: 0.9rem !important;
    flex-shrink: 0 !important; /* CRITICAL: Prevents the circle from squishing */
    cursor: help;
  }

  .project-title {
    margin-top: 0 !important;
    line-height: 1.3 !important;
    /* This ensures long titles wrap properly instead of hitting the icon */
    word-wrap: break-word; 
    color: var(--heading-color) !important;
  }
  
  /* Color classes for badges */
  .bg-completed { background-color: #28a745 !important; color: white !important; }
  .bg-progress { background-color: #ffc107 !important; color: #212529 !important; }
</style>

{% if site.projects %}
  <div id="project-list">
    {% assign projects = site.projects | sort: 'date' | reverse %}
    {% for project in projects %}
      <div class="project-card">
        <div class="d-flex justify-content-between align-items-start mb-2" style="gap: 1rem;"> <h2 class="project-title h4" style="flex: 1; margin-right: 10px;"> {{ project.title }} </h2> {% if project.status %} {% assign s = project.status | downcase | strip %} <div class="badge-status-wrapper" style="flex-shrink: 0;"> <span class="badge-status {% if s == 'completed' %}bg-completed{% else %}bg-progress{% endif %}" title="{{ project.status }}"> {% if s == 'completed' %} <i class="fas fa-check-circle fa-fw"></i> {% else %} <i class="fas fa-hourglass-half"></i> {% endif %} </span> </div> {% endif %} </div>
        
        <div class="project-desc mb-3" style="color: var(--text-color) !important;">
          {{ project.description }}
        </div>

        <div class="d-flex justify-content-between align-items-center mt-auto">
          <div class="text-muted small">
            <i class="far fa-calendar fa-fw"></i>
            {{ project.date | date: "%b %Y" }}
          </div>

          <div class="project-links">
            {% if project.github_url %}
              <a href="{{ project.github_url }}" class="btn btn-outline-primary btn-sm" target="_blank">
                <i class="fab fa-github fa-fw"></i> GitHub
              </a>
            {% endif %}
            {% if project.arxiv_url %}
              <a href="{{ project.arxiv_url }}" class="btn btn-outline-danger btn-sm mx-1" target="_blank">
                <i class="fas fa-file-pdf fa-fw"></i> ArXiv
              </a>
            {% endif %}
            {% if project.pub_url %}
              <a href="{{ project.pub_url }}" class="btn btn-outline-info btn-sm" target="_blank">
                <i class="fas fa-external-link-alt fa-fw"></i> Pub
              </a>
            {% endif %}
          </div>
        </div>
      </div>
    {% endfor %}
  </div>
{% else %}
  <p>No projects found in _projects folder.</p>
{% endif %}