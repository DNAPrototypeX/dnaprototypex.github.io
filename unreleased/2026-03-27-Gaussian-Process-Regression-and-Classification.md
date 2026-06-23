---
title: Gaussian Process Regression and Classification
date: 2026-03-27 12:00:00 -0500
categories:
  - Blogging
  - Machine Learning
tags:
  - coding
  - math
  - machine-learning
media_subpath: /assets/img/gp/
description: The theory behind GP linear models, and application on simple toy regression and classification datasets.
status: In Progress
---
# Intro
<hr style="height: 1px; background-color: var(--heading-color); border: none; opacity: 1;">
A process is a collection of random variables, and a Gaussian process is a process such that any finite combination of its random variables have a joint Gaussian distribution. Essentially, a process is a distribution of random functions. 
# Regression
<hr style="height: 1px; background-color: var(--heading-color); border: none; opacity: 1;">
The basic intuition of a GP regression model is to start with a randomly initialized prior, and update it with new observations (training data). The result is a distribution of functions that has been constrained to contain functions that fit the training data.

![GP Regression Priors](regression_prior.png){:.img-half}
*Gaussian process regression priors.*

![GP Regression Posterior No MML](regression_posterior_non_mml.png){:.img-half}
*Gaussian process regression posterior without maximal marginal likelihood.*

## Maximizing Log Marginal Likelihood
---
![GP Regression Posterior MML](regression_posterior.png){:.img-half}
*Gaussian process regression posteriors with maximal marginal likelihood.*


