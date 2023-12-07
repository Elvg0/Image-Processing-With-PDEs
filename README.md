# PDE's for Image Processing
Matlab implementation of partial differential equation (PDE) models for denoising, segmentation and inpainting.

# Denoising

In order to enhance the quality of noisy images, diffusion based PDEs may be used. The following models are used and implemented in a 1D signal for simplicity:

## Heat Equation Denoising

The linear PDE given by:

$$\begin{cases} u_t - k\Delta u = 0 \\
u(x,0) = u_0(x) \text{ (the noisy image) }
\end{cases}$$

Is equivalent to the Gaussian filtering, as the solution of the heat equation is given by the convolution of the initial conditions owith the heat kernel $\Phi(x,t) = \frac{1}{(4\pi k)^{n/2}} e^{-\frac{x^2}{4kt}}$ with $x \in \mathbb{R}^n$ (naturally $n=2$ with images). So the solution is given by:

$$u(x,t) = \int_\Omega \Phi(x-s,t) u_0(s)ds$$

This solution can be also done discretizing the PDE and applying it to the noisy image. For this purpose, we can expand the equaiton in order to make the process adding the term $\lambda (u-u_0)$, getting the equation:

$$u_t - k\Delta u = \lambda (u-u_0)$$

Discretizing the equation with the forward Euler method, as it is simplest, we get:

$$u_j^{n+1} = u_j^n + dt ( k \frac{u_{j-1}^n -2 u_j^n + u_{j+1}^n}{h^2} + \lambda (u_j^n- u_{0_{j}}^n))$$

Here $dt$ represents the time step, $h$ the space step, $n$ the time point and $j$ the space point. We also have to take into account boundary conditions, where we assume $u(x,t)=0$ in $\partial \Omega$.

## Total Variation Denoising

The total variation denoising denoising using Rudin-Osher-Fatemi (ROF) PDE, seeks to solve the following minimization problem:

$$\min_{u \in BV( \Omega)} \int_\Omega \|| \nabla u \|| + \frac{\lambda}{2} (u-u_0)^2dx$$

Where $BV(\Omega)$ is the set of functions with bounded variation (finite total variation) over the domain. Her $f$ represents the noisy image. Appling the Euler-Lagrange Equation to this functional, we get the PDE:

$$div (\frac{\nabla u}{\|| \nabla u\|| }) + \frac{\lambda}{2} (u-u_0) = 0 $$

We can take the equivalenmt time dependent PDE and iterate over time:

$$u_t =div (\frac{\nabla u}{\|| \nabla u\|| }) + \frac{\lambda}{2} (u-u_0)$$

Discritezing the PDE with forward Euler method and assuming the previous assumptions at the border:

$$u_j^{n+1} = u_j^n + dt \left( \frac{\nabla^+ u}{\sqrt{(\nabla^+ u)^2 + \epsilon}} - \frac{\nabla^- u}{\sqrt{(\nabla^- u)^2 + \epsilon} } + \lambda (u_j^n - u_{0_j}^n)\right)$$

Where $\nabla^+ u = \frac{u_{j+1}^n-u_j^n}{h}, \nabla^- u = \frac{u_{j}^n-u_{j-1}^n}{h}$ correspond to the forward difference and backward difference operator. The value $\epsilon > 0$ is used to prevent division by 0.

