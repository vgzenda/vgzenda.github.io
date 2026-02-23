---
layout: post
title: "TITLE HERE"
date: 2026-02-17 09:00:00 -0500
description: "One-line summary of this post."
tags: [cosserat, math, soft-robotics]
categories: [research-notes]
giscus_comments: true
bibliography: 2025-06-09-cosserat.bib
toc:
  sidebar: left
# Optional: override/add macros just for this post.
# mathjax_macros:
#   RR: "\\mathbb{R}"
#   set: ["\\left\\{#1\\right\\}", 1]
---

## Context

Write your intro paragraph here.

Example citation syntax: `{% raw %}{% cite rus2015design --file 2025-06-09-cosserat %}{% endraw %}`.

## Core Equations

Inline math uses your LaTeX shortcuts, e.g. $\mbR^3$, $\bq$, and $\pp{L}{\bq}$.

Display math with your macros:

$$
\dd{g}{s} = g\,\wh{\mcE}, \qquad \dd{g}{t} = g\,\wh{\mcV}.
$$

$$
\CovDeriv{\Gamma}{t}{\mcV} = \Conn{\Gamma}{\mcV}{\mcV}.
$$

## Figure

![Soft robot examples]({{ '/assets/img/blog/soft-robot-survey.jpg' | relative_url }})

## References Notes

Render cited references at the end with:

```liquid
{% raw %}{% bibliography --file 2025-06-09-cosserat --cited_in_order --group_by none --template bib-simple %}{% endraw %}
```
