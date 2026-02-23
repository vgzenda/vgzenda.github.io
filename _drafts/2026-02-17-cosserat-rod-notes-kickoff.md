---
layout: post
title: "Cosserat Rod Notes: Kickoff Post"
date: 2026-02-17 10:00:00 -0500
description: "Initial blog setup for transferring LaTeX-style notes into web posts."
tags: [cosserat, math, soft-robotics]
categories: [research-notes]
giscus_comments: true
toc:
  sidebar: left
---

This post verifies the blog pipeline and LaTeX macro setup.

Using macros from your preamble:

$$
\dd{g}{s} = g\,\wh{\mcE}, \qquad
\dd{g}{t} = g\,\wh{\mcV}, \qquad
\mcE,\mcV \in \mse(3).
$$

$$
\pp{\mcL}{\bq} - \dd{}{t}\pp{\mcL}{\dot{\bq}} = 0.
$$

![Soft robot examples from survey paper]({{ '/assets/img/blog/soft-robot-survey.jpg' | relative_url }})

You can now copy sections from your LaTeX notes into new Markdown posts and keep most math shortcuts unchanged.
