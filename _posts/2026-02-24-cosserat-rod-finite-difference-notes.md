---
layout: post
title: "Notes on Finite Difference Method for Cosserat Rod Dynamics"
date: 2026-02-24 09:25:00 -0500
description: "Finite-difference discretization and shooting-method boundary value formulation for Cosserat rod dynamics."
tags: [cosserat, geometric-mechanics, finite-difference, soft-robotics]
categories: [research-notes]
thumbnail: /assets/img/blog/soft-robot-survey-1200.jpg
giscus_comments: true
bibliography: 2025-06-09-cosserat.bib
toc:
  sidebar: left
---

### Abstract
These are notes on a finite-difference method for Cosserat rod dynamics, including the geometric formulation of the PDEs and shooting-method boundary value solvers.

## Introduction
Cosserat rods are an important model for soft slender robotic systems such as continuum manipulators. These systems have drawn research interest due to natural compliance with the environment and opportunities for dynamic modeling and numerical simulation {% cite bensch2024physics orekhov2020solving till2015efficient tummers2023cosserat --file 2025-06-09-cosserat %}, state estimation {% cite lilge2022continuum lilge2024state zheng2024estimating --file 2025-06-09-cosserat %}, and control {% cite alqumsan2019robust doroudchi2021configuration --file 2025-06-09-cosserat %}. Soft slender robots have applications in biomedicine {% cite cianchetti2018biomedical --file 2025-06-09-cosserat %}, mobile robotics {% cite zhang2023progress --file 2025-06-09-cosserat %}, and human-robot interaction {% cite polygerinos2017soft --file 2025-06-09-cosserat %}.

<picture>
<source media="" srcset="{{ '/assets/img/blog/soft-robot-survey-1200.jpg' | relative_url }}">
<img
src="{{ '/assets/img/blog/soft-robot-survey-1600.jpg' | relative_url }}"
alt="Examples of soft robotic systems"
style="width: 100%; height: auto; display: block; margin: 0 auto;"
loading="lazy"
>
</picture>
*Examples of soft robotic systems {% cite rus2015design --file 2025-06-09-cosserat %}.*

These notes are meant as a quick refresher on Cosserat rod theory from a geometric mechanics perspective {% cite holm2011geometric marsden1998introduction --file 2025-06-09-cosserat %}. To stay self-contained, we briefly review preliminaries on the Special Euclidean group and Lie-theoretic identities {% cite holm2011geometric --file 2025-06-09-cosserat %}. We then state the strong-form equations of motion and derive a finite-difference discretization in time, followed by boundary value formulations solved with shooting methods {% cite grazioso2017geometric samei2022geometric till2015efficient --file 2025-06-09-cosserat %}. Background sources include geometric mechanics {% cite holm2011geometric holm2009geometric marsden1998introduction --file 2025-06-09-cosserat %} and Cosserat theory {% cite boyer2010poincare boyer2020dynamics caasenbrood2022energy renda2020geometric renda2018unified renda2018discrete --file 2025-06-09-cosserat %}.

## Preliminaries
To keep these notes self-contained, we review rigid motion groups and the strong form of dynamic Cosserat equations using Lie group theory.

### Special Euclidean Group
**Rigid Rotations.** The Special Orthogonal group $SO(3)$ is

$$
\begin{aligned}
SO(3) = \{R \in\mbR^{3\times 3} \, | \, R^T R = I, \quad \det R = 1 \}.
\end{aligned}
$$

Its inverse is $R^{-1} = R^T$. Its Lie algebra $\mso(3) \subset \mbR^{3\times 3}$ is the set of skew-symmetric matrices, and can be identified with $T_I SO(3)$ {% cite holm2009geometric marsden1998introduction --file 2025-06-09-cosserat %}. The hat map preserves Lie algebra structure:

$$
\begin{aligned}
\wh{\bOm\times\br} = \wh{\bOm}\wh{\br} - \wh{\br}\wh{\bOm}.
\end{aligned}
$$

**Rigid Motion.** The Special Euclidean group $SE(3) = SO(3)\times\mbR^3$ is represented by

$$
\begin{aligned}
g = \begin{bmatrix}
R & \br\\ \bzero & 1
\end{bmatrix}, \quad g^{-1} = \begin{bmatrix}
R^T & -R^T\br\\ \bzero & 1
\end{bmatrix}.
\end{aligned}
$$

Its Lie algebra $\mse(3)=\mso(3)\times\mbR^3$ can be represented as

$$
\begin{aligned}
\wh{\bX} = \begin{bmatrix}
\wh{\bOm}& \bv \\ \bzero & 0
\end{bmatrix}, \quad
\wh{\bX}^\vee = \begin{bmatrix}
\bOm \\ \bv
\end{bmatrix}.
\end{aligned}
$$

For $g=(R,\br)\in SE(3)$ and $\wh{\bX}\in\mse(3)$:

$$
\begin{aligned}
[\Ad_g] = \begin{bmatrix}
R & \wh{\br}R \\ \mbO & R
\end{bmatrix}, \quad
[\ad_{\wh{\bX}}] = \begin{bmatrix}
\wh{\bOm} & \wh{\bv} \\ \mbO & \wh{\bOm}
\end{bmatrix}.
\end{aligned}
$$

The coAdjoint and coadjoint maps are

$$
\begin{aligned}
[\Ad_g^*] = \begin{bmatrix}
R^T & \mbO \\ -R^T\wh{\br} & R^T
\end{bmatrix}, \quad
[\ad_{\wh{\bX}}^*] = \begin{bmatrix}
-\wh{\bOm} & \mbO \\ -\wh{\bv} & -\wh{\bOm}
\end{bmatrix}.
\end{aligned}
$$

### Cosserat Rod Dynamics
<picture>
<source media="(max-width: 900px)" srcset="{{ '/assets/img/blog/cosserat-rod-diagram.jpg' | relative_url }}">
<img
src="{{ '/assets/img/blog/cosserat-rod-diagram.jpg' | relative_url }}"
alt="Illustration of a Cosserat rod"
style="width: 100%; height: auto; display: block; margin: 0 auto;"
loading="lazy"
>
</picture>

The configuration space for a rod of length $L$ is
$\mcQ = \{g(s)\in SE(3)\,|\,s\in[0,L]\}$.
A motion $g(s,t)$ is a smooth two-parameter surface in $SE(3)$. The body-frame strain field is

$$
\begin{aligned}
\mcE(s,t) = \left(g^{-1}(s,t)\pp{g}{s}(s,t)\right)^\vee =
\begin{bmatrix}
\bK(s,t) \\ \bGam(s,t)
\end{bmatrix},
\end{aligned}
$$

and the body velocity field is

$$
\begin{aligned}
\mcV(s,t) = \left(g^{-1}(s,t)\pp{g}{t}(s,t)\right)^\vee =
\begin{bmatrix}
\bOm(s,t) \\ \bV(s,t)
\end{bmatrix}.
\end{aligned}
$$

**Lemma.** The compatibility condition for $g(s,t)\in C^2(SE(3))$ is

$$
\begin{aligned}
\pp{\mcV}{s} = \ad_{\mcV}\mcE + \pp{\mcE}{t}.
\end{aligned}
$$

**Proof.** Follows by a direct computation from commutativity of mixed partial derivatives.

A reduced Lagrangian density is

$$
\begin{aligned}
L(\mcV,\mcE)=\frac{1}{2}\mcV^T\mbM(s)\mcV
-\left(\mcE-\mcE^*\right)^T\mbK(s)\left(\mcE-\mcE^*\right),
\end{aligned}
$$

where $\mbM$ is the mass matrix per unit length, $\mbK$ is the stiffness matrix per unit length, and $\mcE^*$ is the reference strain.

**Lemma.** Let $\wh{\bpsi}=g^{-1}\delta g\in\mse(3)$. Then

$$
\begin{aligned}
\delta\mcV = \pp{\bpsi}{t} + \ad_{\mcV}\bpsi, \quad
\delta\mcE = \pp{\bpsi}{s} + \ad_{\mcE}\bpsi.
\end{aligned}
$$

**Proof.** A straightforward computation.

Assuming external force density $\bF_{ext}$, viscoelastic strain term $\mbD\dot{\mcE}$, and active constitutive law $\bLambda_a$, the virtual work variation is

$$
\begin{aligned}
\delta W_{ext}
&= \int_0^L \aaa{\bF_{ext},\psi_g} + \aaa{\bLambda_{ext},\delta\mcE_h}\,ds \\
&\quad + \aaa{\bF_{ext,BC}(0),\bpsi_g(0)} - \aaa{\bF_{ext,BC}(L),\bpsi_g(L)},
\end{aligned}
$$

with $\bLambda_{ext}=\mbD\pp{\mcE}{t}+\bLambda_a$.

**Theorem (Strong Cosserat Equations of Motion).**
Let $g(s,t)$ be a rod motion with fields $\mcV(s,t)$ and $\mcE(s,t)$, with external work from $\bF_{ext}$, viscoelastic material term, and active constitutive law. The strong-form PDEs are

$$
\begin{aligned}
&\pp{}{s}g = g\wh{\mcE}, \quad \pp{}{t}g = g\wh{\mcV}, \\
&\pp{}{s}\mcV = \pp{}{t}\mcE + \ad_{\mcV}\mcE, \\
&\pp{}{s}\bLambda = \pp{}{t}(\mbM\mcV) - \ad^*_{\mcV}\mbM\mcV + \ad^*_{\mcE}\bLambda - \bF_{ext},
\end{aligned}
$$

where

$$
\begin{aligned}
\bLambda = \mbK(\mcE-\mcE^*) + \mbD\pp{\mcE}{t} + \bLambda_a.
\end{aligned}
$$

Boundary conditions are either:

1. Cantilevered boundary conditions:

$$
\begin{aligned}
g(0,t)=g_0(t), \quad \mcV(0,t)=\mcV_0(t), \quad \bLambda(L,t)=\bF_{BC,L}(t).
\end{aligned}
$$

2. Free-free boundary conditions:

$$
\begin{aligned}
\bLambda(0,t)=-\bF_{BC,0}(t), \quad \bLambda(L,t)=\bF_{BC,L}(t).
\end{aligned}
$$

**Proof.** Follows from Hamilton's variational principle.

## Finite Difference Method
For the two-parameter Cosserat PDEs, time derivatives are discretized with a second-order backward difference:

$$
\begin{aligned}
\pp{}{t}\mcE(s,t) &\approx \frac{1}{\Delta t}\left(\frac{3}{2}\mcE(s,t)-2\mcE(s,t-\Delta t)+\frac{1}{2}\mcE(s,t-2\Delta t)\right), \\
\pp{}{t}\mcV(s,t) &\approx \frac{1}{\Delta t}\left(\frac{3}{2}\mcV(s,t)-2\mcV(s,t-\Delta t)+\frac{1}{2}\mcV(s,t-2\Delta t)\right).
\end{aligned}
$$

Define

$$
\begin{aligned}
\pp{}{t}\mcE(s,t) &\approx c_0\mcE(s,t)+\mcE^h(s,t), \\
\pp{}{t}\mcV(s,t) &\approx c_0\mcV(s,t)+\mcV^h(s,t), \\
c_0&=\frac{3}{2\Delta t},\quad c_1=-\frac{2}{\Delta t},\quad c_2=\frac{1}{2\Delta t}.
\end{aligned}
$$

Then the semi-discrete system in space is

$$
\begin{aligned}
&\pp{}{s}g = g\wh{\mcE}, \\
&\pp{}{s}\mcV = c_0\mcE(s,t)+\mcE^h(s,t)+\ad_{\mcV}\mcE, \\
&\pp{}{s}\bLambda = \mbM\left(c_0\mcV(s,t)+\mcV^h(s,t)\right)-\ad^*_{\mcV}\mbM\mcV+\ad^*_{\mcE}\bLambda-\bF_{ext}, \\
&\mcE(s,t)=\left(\mbK+c_0\mbD\right)^{-1}\left(\bLambda-\bLambda_a+\mbK\mcE^*(s)-\mbD\mcE^h(s,t)\right).
\end{aligned}
$$

with either cantilevered or free-free boundary conditions as above.

### Boundary Value Problem

### Cantilevered B.C.
For the cantilevered case, at each time step $t$ we are given tip boundary force $F_{BC,L}(t)$ and initial conditions $g_0(t)$, $\mcV_0(t)$. We solve for an initial stress guess by minimizing

$$
\begin{aligned}
\mcL = ||\bLambda_{integrated}(g_0,\mcV_0,\bLambda_{0,guess}) - \bF_{BC,L}||^2.
\end{aligned}
$$

Here, shooting means optimizing a guess of initial conditions $(g_0(t),\mcV_0(t),\bLambda(0,t))$ and integrating so that $\bLambda(L,t)=\bF_{BC,L}(t)$ is satisfied. The optimization can be solved with Levenberg-Marquardt.

{% include video.liquid
  path="assets/video/FDM_rod_animation_clamped.mp4"
  class="img-fluid rounded z-depth-1"
  controls=true
  muted=true
  loop=true
  caption="Simulation of Cosserat rod dynamics with clamped boundary conditions and sinusodal tendon inputs."
%}



### Free-Free Boundary Conditions
For free-free conditions, both endpoints are free. We parameterize the base point $g(0)=g_0=(R_0,\br_0)\in SO(3)\times\mbR^3$ and solve for it at each step. Assuming step-$n$ states are known, we apply a Newmark-beta update {% cite boyer2022statics --file 2025-06-09-cosserat %}:

$$
\begin{aligned}
\br_{0,n+1} &= a\ddot{\br}_{0,n+1}+\bff_n, \\
\dot{\br}_{0,n+1} &= b\ddot{\br}_{0,n+1}+\bh_n,
\end{aligned}
$$

with

$$
\begin{aligned}
a &= \beta\Delta t^2, \quad b=\beta\Delta t^2, \\
\bff_n &= \br_{0,n}+\Delta t\dot{\br}_{0,n}+\Delta t^2\left(\frac{1}{2}-\beta\right)\ddot{\br}_{0,n}, \\
\bh_n &= \dot{\br}_{0,n}+\Delta t(1-\gamma)\ddot{\br}_{0,n}.
\end{aligned}
$$

Rotation updates are

$$
\begin{aligned}
\bTheta_{0,n+1} &= a\dot{\bOm}_{0,n+1}+\boldsymbol{k}_n, \quad
\bOm_{0,n+1}=b\dot{\bOm}_{0,n+1}+\boldsymbol{l}_n, \\
\boldsymbol{k}_n &= \Delta t\bOm_{0,n}+\Delta t^2\left(\frac{1}{2}-\beta\right)\dot{\bOm}_{0,n}, \quad
\boldsymbol{l}_n=\bOm_{0,n}+\Delta t(1-\gamma)\dot{\bOm}_{0,n},
\end{aligned}
$$

and

$$
\begin{aligned}
R_{0,n+1}=R_{0,n}\exp(\wh{\bTheta}_{0,n+1}).
\end{aligned}
$$

Kinematic relations:

$$
\begin{aligned}
g_0 &= \begin{bmatrix}
R_0\exp(\wh\bTheta_0) & \br_0 \\ \bzero & 1
\end{bmatrix}, \\
\mcV_0 &= \begin{bmatrix}
\bOm_0 \\ R_0^T\dot{\br}_0
\end{bmatrix}, \\
\dot{\mcV}_0 &= \begin{bmatrix}
\dot{\bOm}_0 \\ R_0^T\ddot{\br}_0 + (R_0^T\dot{\br}_0)\times\bOm_0
\end{bmatrix}.
\end{aligned}
$$

Parameterizing $\bphi_0=(\bTheta_0,\br_0)\in\mbR^6$:

$$
\begin{aligned}
g_0=\mbA(\bphi_0), \quad \dot{\mcV}_0=\mbB(\bphi_0), \quad \dot{\mcV}_0=\mbC(\bphi_0).
\end{aligned}
$$

with

$$
\begin{aligned}
\mbA(\bphi_0) &= \begin{bmatrix}
R_0\exp(\wh\bTheta_0) & \br_0 \\ \bzero & 1
\end{bmatrix}, \\
\mbB(\bphi_0) &= \begin{bmatrix}
\tl{a}\bTheta_0+\tl{\boldsymbol{k}}_n \\ R_0^T(\tl{b}\br_0+\tl{\boldsymbol{h}}_n)
\end{bmatrix}, \\
\mbC(\bphi_0) &= \begin{bmatrix}
\tl{b}\bTheta_0+\tl{\boldsymbol{l}}_n \\ R_0^T(\tl{b}\br_0+\tl{\boldsymbol{h}}_n)+\bV_0\times\bOm_0
\end{bmatrix}.
\end{aligned}
$$

Parameters:

$$
\begin{aligned}
R_0^T &= \exp(\wh\bTheta_0)R_{0,n}^T, \quad \tl{b}=a^{-1}, \quad \tl{a}=b\tl{b}, \\
\tl{\boldsymbol{h}}_n &= -b\bff_n, \quad \tl\bff_n = \boldsymbol{h}_n-\tl{a}\bff_n, \\
\tl{\boldsymbol{l}}_n &= -\tl{b}\boldsymbol{k}_n, \quad \tl{\boldsymbol{k}}_n = \boldsymbol{l}_n-\tl{a}\boldsymbol{k}_n.
\end{aligned}
$$

Jacobians:

$$
\begin{aligned}
\pp{\mbA}{\bphi_0} &= \begin{bmatrix}
T(\bTheta_0) & \bzero \\ \bzero & R_0^T
\end{bmatrix}, \\
\pp{\mbB}{\bphi_0} &= \begin{bmatrix}
\tl{a}\mbI_{3\times 3} & \mbO \\ \wh\bV_0T(\bTheta_0) & \tl{a}R_0^T
\end{bmatrix}, \\
\pp{\mbC}{\bphi_0} &= \begin{bmatrix}
\tl{b}\mbI_{3\times 3} & \mbO \\
\left(\wh{\bA}_0-\wh{\bOm}_0\wh{\bV}_0\right)T(\bTheta_0)+\tl{a}\wh{\bV}_0 & \left(\tl{b}\mbI_{3\times 3}-\tl{a}\wh{\bOm}_0\right)R_0^T
\end{bmatrix}.
\end{aligned}
$$

where $$\bA_0=\dot{\bV}_0+\bOm_0\times\bV_0$ and $(R_0^T\Delta R_0)^\vee=T(\bTheta_0)\Delta\bTheta_0$$. At each time step, with base and tip boundary forces $F_{BC,0}(t),F_{BC,L}(t)$, we solve

$$
\begin{aligned}
\mcL = ||\bLambda_{integrated}(\bphi_{0,guess}) - \bF_{BC,L}||^2,
\end{aligned}
$$

using Levenberg-Marquardt.

{% include video.liquid
  path="assets/video/FDM_rod_animation_free-free5s.mp4"
  class="img-fluid rounded z-depth-1"
  controls=true
  muted=true
  loop=true
  caption="Simulation of Cosserat rod dynamics with free-free boundary conditions and an input force to the boundary."
%}

Its worth mentioning that the FDM for free-free boundary conditions is very sensitive to the time and spatial integration, making it difficult to converge to the true solution.


## Conclusion
These notes reviewed Cosserat rod equations and finite-difference simulation in a Lie-group representation. We stated cantilevered and free-free boundary value problems and outlined shooting-method solutions. Future work includes stronger free-free formulations, contact-force models {% cite xun2023cosserat --file 2025-06-09-cosserat %}, and numerical stability analysis for finite-difference schemes in soft robotic systems {% cite boyer2022statics --file 2025-06-09-cosserat %}.

## References
{% bibliography --file 2025-06-09-cosserat --cited_in_order --group_by none --template bib-simple %}
