{smcl}
{* *! version 1.1  5nov2019}{...}
{cmd:help stackreg} and {cmd:help xtstackreg}{right: ({browse "https://doi.org/10.1177/1536867X211025801":SJ21-2: st0641})}
{hline}

{title:Title}

{p2colset 5 17 19 2}{...}
{p2col:{cmd:stackreg} {hline 2}}Stacked linear regression analysis to facilitate testing of multiple hypotheses{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 16 2}
{cmd:stackreg} {it:{help varlist:depvars}} {cmd:=} 
{it:{help varlist:indepvars}} {ifin} {weight} [{cmd:,} {it:{help stackreg##options:options}}] 

{p 8 18 2}
{cmd:xtstackreg} {it:{help varlist:depvars}} {cmd:=} 
{it:{help varlist:indepvars}} {ifin} {weight} [{cmd:,} {it:{help stackreg##options:options}}] 


{phang}
{it:depvars} specifies the list of dependent variables in the stacked
regression.  {it:depvars} may include factor variables and hence allows for
straightforwardly considering interactions and polynomials in the regressions
that precede the joint test of multiple hypotheses.

{phang}
{it:indepvars} specifies the list of independent variables in the stacked
regression.  In a basic setting of a balancing check, {it:indepvars}
consists of a single treatment indicator.  Yet, more involved analyses may
require a more complex specification of {it:indepvars}.  One example is a
difference-in-differences setting, where the common-trend assumption implies
that the interaction of the posttreatment-period indicator ({it:post}) and
treatment-group indicator ({it:tgroup}) has no explanatory power for any
element of {it:depvars}.  In this example, {it:indepvars} is specified as
{it:post}{cmd:##}{it:tgroup}, and the joint null hypothesis can be tested with
{cmd:testparm post#tgroup} after running {cmd:stackreg}; see 
{help stackreg##example1:example 1}.  {it:indepvars} may include factor
variables.


{synoptset 20}{...}
{synopthdr :options}
{synoptline}
{synopt :{opt fe}}apply within-transformation to {it:depvars} and
{it:indepvars} (equivalent to using {cmd:xtstackreg}){p_end}
{synopt :{cmdab:nocons:tant}}suppress constant term{p_end}
{synopt :{cmdab:c:onstraints}{bf:(}{help numlist:{it:numlist}}{bf:)}}apply specified linear constraints{p_end}
{synopt :{cmdab:nocom:mon}}keep observations with any non-missing values in {it:depvars}{p_end}
{synopt :{cmdab:clu:ster}{bf:(}{help varlist:{it:clustvarlist}}{bf:)}}estimate
clustered standard errors (level of clustering higher than observations unit){p_end}
{synopt :{opt df}{bf:(}{bf:adjust}|{bf:raw}|{bf:areg}{bf:)}}degrees-of-freedom adjustment{p_end}
{synopt :{cmdab:w:ald}}use Wald instead of F test after {cmd:stackreg}{p_end}
{synopt :{cmdab:sr:eshape}}use {cmd:sreshape} to increase speed{p_end}
{synopt :{opt lev:el(#)}}set confidence level; default as set by {helpb level:set level}{p_end}
{synopt :{opt edit:tozero(#)}}edit coefficient covariance matrix for roundoff error (zeros); see {helpb mf_edittozero:edittozero()}{p_end}
{synopt :{opt omit:ted}}display omitted collinear variables{p_end}
{synopt :{opt empty:cells}}display empty cells for interactions of factor variables{p_end}
{synopt :{help stackreg##display_options :{it:display_options}}}further options for displaying output{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:depvars} and {it:indepvars} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}{help ereturn##display_options :{it:display_options}} are those available for {cmd:ereturn display}.{p_end}
{p 4 6 2}The prefix commands {cmd:bootstrap} and {cmd:jackknife} are allowed; {cmd:by} and {cmd:svy} are not allowed; see {help prefix}.{p_end}
{p 4 6 2}
{opt pweight}s, {opt aweight}s, {opt fweight}s, and {opt iweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}The available postestimation commands are (almost) the same as for {cmd:regress}; see 
{help regress_postestimation :regress postestimation}.{p_end}
{p 4 6 2}{cmd:predict} and {cmd:margins} behave in the same way as they behave after {cmd:mvreg}; see {help mvreg_postestimation :mvreg postestimation}.{p_end} 


{title:Description}

{pstd}
{cmd:stackreg} implements a stacked regression analysis, which facilitates
statistical testing in a multiple-testing framework.  The stacked regression
approach was suggested by, for example, Weesie (1999) and Pei, Pischke, and
Schwandt (2019).  {cmd:stackreg} is closely related to the Stata {helpb suest}
command.  Unlike {cmd:suest}, which is extremely flexible in allowing
inference involving regression models of different type, {cmd:stackreg} is
confined to the linear model.  However, in the context of the linear model,
{cmd:stackreg} is more flexible than {cmd:suest} in several respects.  In
detail, i) {cmd:stackreg} accommodates multiway clustering (Cameron, Gelbach,
and Miller 2011), if the community-distributed command {helpb cgmreg} (Gelbach
and Miller 2009) is installed; ii) {cmd:stackreg} allows for imposing
cross-equation constraints by specifying the {cmd:constraints()} option; iii)
{cmd:stackreg} is a panel-data command that accommodates fixed-effects
estimation; iv) unlike {cmd:suest}, {cmd:stackreg} applies a
degrees-of-freedom adjustment that exactly reproduces the standard errors that
equation-by-equation estimation yields; and v) {cmd:stackreg} allows for
factor variables in {it:depvars}.

{pstd}
{cmd:stackreg} can also be regarded as a more robust alternative to
{helpb sureg} and {helpb mvreg} in particular.  While these commands implement
a feasible generalized least-squares estimator and, hence, rely on strong
assumptions when estimating cross-equation coefficient covariances,
{cmd:stackreg} uses clustering in the same fashion as {cmd:suest}.  The
stacked regression approach may alternatively be implemented using the data
management tool {helpb stack}.  Implementing the stacked regression approach
on the basis of {cmd:stack} is, however, cumbersome, in particular with panel
fixed-effects estimation.

{pstd}
Technically, {cmd:stackreg} runs a simple ordinary least-squares regression in
which the left-hand-side variable is the stacked variable in {it:depvars},
while the variables in {it:indepvars} enter the right-hand side as a saturated
set of interactions with indicators for each element of {it:indepvars}.  In
terms of the estimated coefficients and standard errors, this is fully
equivalent to separately regressing each element of {it:depvars} on
{it:indepvars}, unless cross-equation restrictions are imposed on the
coefficients.  However, unlike separate regressions, the stacked approach
inherently accommodates estimating coefficient covariances across equations.
This is important for testing hypotheses that involve coefficients from more
than one equation.

{pstd}
{cmd:stackreg} is not an estimation procedure in its own right but a procedure
that prepares the foundation for jointly testing multiple hypotheses.  After
running {cmd:stackreg}, {cmd:test} or {cmd:testparm} can be used in the usual
fashion to test hypotheses that involve coefficients from different equations.
{cmd:xtstackreg} is the same as {cmd:stackreg, fe}.


{marker options}{...}
{title:Options}

{phang}
{opt fe} makes {cmd:stackreg} use within-transformed values of {it:indepvars}
and {it:depvars} rather than their levels when estimating the stacked
regression.  That is, with the option {cmd:fe} (fixed effects), {cmd:stackreg}
eliminates unobserved individual heterogeneity.  {opt fe} requires that the
data are declared as panel data by using {helpb xtset}.  {cmd:stackreg} with
the {opt fe} option is fully equivalent to {cmd:xtstackreg} (with and without
the {opt fe} option, that is, {opt fe} has no effect with {cmd:xtstackreg}).
We provide the separate {opt xt} command to make more salient that
{cmd:stackreg} can be used with panel data.

{phang}
{opt noconstant} suppresses the constant terms in the stacked regression.
{cmd:noconstant} drops the constant terms from all regression equations
because {cmd:stackreg} considers the same set of explanatory variables for all
equations.

{phang}
{opt constraints(numlist)} requests that {cmd:stackreg} apply the linear
constraints specified by {it:numlist}, which must comply with Stata's
{it:{help numlist:numlist}} syntax.  The specified constraints must be defined
in advance by using {helpb constraint}.  The syntax for referring to a
coefficient when defining constraints is
{cmd:[}{it:depvar}{cmd:]}{it:indepvar}.  To identify coefficients, both the
equation and the explanatory variable are thereby specified.  Factor-variables
syntax is allowed for specifying constraints, for example,
{cmd:[health]1998.year = 0}.  Cross-equation constraints can be defined as
usual, for example, {cmd:[health]income = [happiness]income}.  The
{cmd:constraints()} option cannot be combined with multiway clustering.  If
{cmd:constraints()} is specified and {cmd:noconstant} is not specified, then
{cmd:stackreg} estimates an overall constant and drops the equation-specific
constant from the final equation.

{phang}
{opt nocommon} makes {cmd:stackreg} select the estimation sample on an
equation-by-equation basis.  That is, observations for which information on
some variables in {it:depvars} is missing are used, and the number of
observations thus may vary across the different equations.  The default
({cmd:common}) is to only consider observations for which information is
available for all variables in {it:depvars}.  Whether or not the estimation
sample is heterogeneous across equations is stored in {cmd:e(common)}.

{phang}
{opt cluster(clustvarlist)} makes {cmd:stackreg} cluster the standard errors
(and covariances) at a higher level than the original unit of observation.  By
default, an identifier of the original observations serves as {it:clustvar},
because stacking the regression makes each original sampling unit contribute
several observations to the stacked regression analysis.  {cmd:stackreg}
accommodates multiway higher-level clustering; that is, {it:clustvarlist} may
consist of more than one variable.  Multiway clustering requires the
community-contributed command {helpb cgmreg} (by Gelbach and Miller [2009]) to
be installed.  {cmd:stackreg} has been tested with {cmd:cgmreg} version 3.0.0
(Gelbach and Miller 2009).  Other versions of {cmd:cgmreg} may behave
differently and might make {cmd:stackreg} fail or produce incorrect results.

{phang}
{cmd:df(adjust}|{cmd:raw}|{cmd:areg)} specifies the type of degrees-of-freedom
adjustment {cmd:stackreg} applies.  The default is {cmd:df(adjust)}.  With
{cmd:df(adjust)}, {cmd:stackreg} adjusts the degrees-of-freedom correction
such that the reported standard errors coincide with those one gets from
separately regressing the elements of {it:depvars} on {it:indepvars}, using
{cmd:regress} with the option {cmd:robust}.  This, depending on how the
{cmd:cluster()} option is specified, likewise applies to the standard errors
one gets from {cmd:regress,} {cmd:cluster()} and {cmd:cgmreg,}
{cmd:cluster()}, respectively.  In the most simple case (no higher-level
clustering, no panel data, homogeneous number of observations across
{it:depvars}), the initially estimated variance-covariance matrix is adjusted
by the factor (N-1)/(N-1/G), with N denoting the genuine number of
observations and G denoting the number of variables in {it:depvars}.  (With
multilevel clustering and the {cmd:nocommon} option, the match with the
standard errors from {cmd:cgmreg} may not be perfect.  See Cameron, Gelbach,
and Miller (2011) for different approaches to the degrees-of-freedom
correction in a multilevel-clustering setting; some are based on internal
results not accessible via what {cmd:cgmreg} stores in {cmd:e()}.) 

{pmore}
For {cmd:xtstackreg}, the default -- that is, {cmd:df(adjust)} -- is to adjust
the degrees-of-freedom correction such that the standard errors coincide with
those from {cmd:xtreg,} {cmd:fe robust} and {cmd:xtreg,} {cmd:fe}
{cmd:cluster()}, respectively.  This implies that {cmd:xtstackreg}, by
default, clusters the standard errors at the level of {it:panelvar}, which is
the default with {cmd:xtreg,} {cmd:fe robust}.  If {cmd:df(areg)} is
specified, {cmd:xtstackreg} adjusts the degrees of freedom such that the
standard errors match those from {cmd:areg,} {opt absorb(panelvar)}
{cmd:robust} and {cmd:areg,} {opt absorb(panelvar)} {cmd:cluster()},
respectively.  That is, with {cmd:df(areg)}, {cmd:stackreg} does not cluster
the standard errors at the level of {it:panelvar} unless this is explicitly
requested with {opt cluster(panelvar)}.  {cmd:df(areg)} is ignored by
{cmd:stackreg} if the {cmd:fe} option is not specified.  {cmd:df(raw)}
prevents {cmd:stackreg} from adjusting the degrees-of-freedom correction to
the stacked regression setting.

{phang}
{cmd:wald} makes {cmd:test} and {cmd:testparm} apply a Wald rather than an F
test after {cmd:stackreg}.  This is achieved through preventing {cmd:stackreg}
from saving the residual degrees of freedom in {cmd:e(df_r)}.  With multiway
clustering, as with heterogeneous estimation samples across the different
regression equations, {cmd:e(df_r)} is never stored, because there is no
(universal) answer to the question of what the number of clusters is.  Thus,
{cmd:test} and {cmd:testparm} apply a Wald test in these cases, even if the
{cmd:wald} option is not specified.

{phang}
{cmd:sreshape} requests that {cmd:stackreg} call the community-contributed
command {cmd:sreshape} (Simons 2016) instead of {cmd:reshape}.  Because
{cmd:sreshape} is much faster than {cmd:reshape} (Simons 2016) in many
settings, specifying {cmd:sreshape} may speed up {cmd:stackreg}.

{phang}
{opt level(#)}; see 
{helpb estimation options##level():[R] Estimation options}.  The reported
confidence level can be changed by retyping {cmd:stackreg} without arguments
and only specifying the {opt level(#)} option.

{phang}
{opt edittozero(#)} specifies how numerically close to 0 an element of the
estimated variance-covariance needs to be to set its value to 0.  The
specified value is passed through to the Mata function {helpb edittozero()}.
The default is {cmd:edittozero(1)}.  The different estimation commands that
are alternatively called by {cmd:stackreg} may differ with respect to how
estimated coefficient variances that are close to 0 are dealt with.
Specifying {cmd:edittozero()} aligns their behaviors.

{phang}
{opt omitted} specifies that variables that were omitted because of
collinearity be displayed and labeled as {cmd:(omitted)}.  Unlike many Stata
commands, the default is not to include in the results table any variables
omitted because of collinearity.  This is the default because {cmd:stackreg}
regularly generates rather larger results tables due to {it:depvars}
consisting of numerous variables.  This applies in particular if factor
variables are used.  Hence, listing omitted variables may render the output
hard to read.

{phang}
{cmd:emptycells} specifies that empty cells for interactions of factor
variables be displayed and labeled as {cmd:(empty)}.  The default is not to
include them in the results table, for the same reason as the default for the
{cmd:omitted} option.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noci},
{opt nopv:alues},
{opt noomit:ted},
{opt vsquish},
{opt noempty:cells},
{opt base:levels},
{opt allbase:levels},
{opt nofvlab:el},
{opt fvwrap(#)},
{opt fvwrapon(style)},
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
see {helpb estimation options##display_options:[R] Estimation options}.


{marker example1}{...}
{title:Example 1} 

{pstd}
From Wooldridge (2010, 456); difference-in-differences analysis, effect of new
garbage incinerator on house prices.

{pstd}
Load data{p_end}
{phang2}{cmd:. use http://fmwww.bc.edu/ec-p/data/wooldridge/kielmc}{p_end}

{pstd}
Regression of primary interest (difference-in-differences with controls){p_end}
{phang2}{cmd:. regress rprice age c.age#c.age intst area land rooms baths y81##nearinc}{p_end}

{pstd}
Stacked balancing regression{p_end}
{phang2}{cmd:. stackreg age c.age#c.age intst area land rooms baths = y81##nearinc}{p_end}

{pstd}
Test of joint significance of interaction of posttreatment-period
indicator {cmd:y81} and treatment-group indicator {cmd:nearinc}{p_end}
{phang2}{cmd:. testparm y81#nearinc}{p_end}


{title:Example 2}

{pstd}
From Wooldridge (2010, 506-507); fixed-effects estimation, effect of market
concentration on flight fares; second outcome {cmd:lpassen} (log-number of
passengers) added.

{pstd}
Load data{p_end}
{phang2}{cmd:. use http://fmwww.bc.edu/ec-p/data/wooldridge/airfare, clear}{p_end}

{pstd}
Stacked fixed-effects estimation (standard errors match those from {cmd:xtreg, fe robust}){p_end}
{phang2}{cmd:. xtstackreg lfare lpassen = concen i.year}{p_end}

{pstd}
Test of null that market concentration affects neither the fare nor the number of passengers{p_end}
{phang2}{cmd:. test concen}{p_end}

{pstd}
Same as above with standard errors that match those from {cmd:areg, absorb(id) robust}{p_end}
{phang2}{cmd:. xtstackreg lfare lpassen = concen i.year, df(areg)}{p_end}
{phang2}{cmd:. test concen}{p_end}

{pstd}
Same as above with two-way (origin and destination) clustering ({cmd:cgmreg} called from {cmd:stackreg}){p_end}
{phang2}{cmd:. egen gorigin = group(origin)}{p_end}
{phang2}{cmd:. egen gdestin = group(destin)}{p_end}
{phang2}{cmd:. xtstackreg lfare lpassen = concen i.year, cluster(gorigin gdestin)}{p_end}
{phang2}{cmd:. test concen}{p_end}
 

{title:Stored results}

{pstd}
{cmd:stackreg} and {cmd:xtstackreg} store the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations (not expanded by stacking){p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(N_g)}}number of groups (only stored with {cmd:xtstackreg} or
the {cmd:fe} option){p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(N_stack)}}number of observations in stacked regression{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom (only stored if {cmd:wald}
is not specified and {cmd:e(common)}: {cmd:common} and {cmd:e(estimator)}:
{cmd:regress}){p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom (only stored if
{cmd:e(common)}: {cmd:common}){p_end}
{synopt:{cmd:e(N_}{it:l}{cmd:)}}number of observations {it:l}th equation (only stored if
{cmd:e(common)}: {cmd:nocommon}){p_end}
{synopt:{cmd:e(rank_}{it:l}{cmd:)}}rank of lth block ({it:l}th equation) of {cmd:e(V)} (only
stored if {cmd:e(common)}: {cmd:nocommon} or {cmd:e(estimator)}: {cmd:cnsreg}){p_end}
{synopt:{cmd:e(df_r_}{it:l}{cmd:)}}residual degrees of freedom {it:l}th equation (only stored
if {cmd:e(common)}: {cmd:nocommon}){p_end}
{synopt:{cmd:e(df_m_}{it:l}{cmd:)}}model degrees of freedom {it:l}th equation (only stored if
{cmd:e(common)}: {cmd:nocommon} or {cmd:e(estimator)}: {cmd:cnsreg}){p_end}
{synopt:{cmd:e(level)}}confidence level{p_end}

{synoptset 20 tabbed}{...} 
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:stackreg} or {cmd:xtstackreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}names in {it:depvars}{p_end}
{synopt:{cmd:e(eqnames)}}names in {it:depvars}{p_end}
{synopt:{cmd:e(title)}}{cmd:Stacked Regression}{p_end}
{synopt:{cmd:e(estimator)}}{cmd:regress}, {cmd:cnsreg}, or {cmd:cgmreg}{p_end}
{synopt:{cmd:e(model)}}{cmd:ols} or {cmd:fe}{p_end}
{synopt:{cmd:e(common)}}{cmd:common} or {cmd:nocommon} ({cmd:nocommon} indicates that the estimation sample varies across equations){p_end}
{synopt:{cmd:e(vcetype)}}{cmd:Clust. Robust}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}vector of estimated coefficients{p_end}
{synopt:{cmd:e(V)}}estimated coefficient variance-covariance matrix{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix (only stored if {cmd:e(estimator)}:
{cmd:cnsreg}){p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Function}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{title:References}

{phang}
Cameron, A. C., J. B. Gelbach, and D. L. Miller. 2011. Robust inference with
multiway clustering. {it:Journal of Business & Economic Statistics} 29:
238-249.  {browse "https://doi.org/10.1198/jbes.2010.07136"}.

{phang}
Gelbach, J. B., and D. L. Miller. 2009. The community-contributed command
cgmreg version 3.0.0.
{browse "http://cameron.econ.ucdavis.edu/research/cgmreg.ado"}.

{phang}
Pei, Z., J.-S. Pischke, and H. Schwandt. 2019. Poorly measured confounders are
more useful on the left than on the right.
{it:Journal of Business & Economic Statistics} 37: 205-216.
{browse "https://doi.org/10.1080/07350015.2018.1462710"}.

{phang}
Simons, K. L. 2016. A sparser, speedier reshape.
{it:Stata Journal} 16: 632-649.
{browse "https://doi.org/10.1177/1536867X1601600305"}.

{phang}
Weesie, J. 1999. sg121: Seemingly unrelated estimation and the
cluster-adjusted sandwich estimator. {it:Stata Technical Bulletin}
52: 34-47. Reprinted in {it:Stata Technical Bulletin Reprints}. 
Vol. 9, pp. 231-248. College Station, TX: Stata Press.

{phang}
Wooldridge, J. M. 2010.
{it:Econometric Analysis of Cross Section and Panel Data}.
2nd ed. Cambridge, MA: MIT Press.


{title:Acknowledgments}

{pstd}
We thank Julia Lang, Johannes Ludsteck, Sabrina Schubert, and an
anonymous reviewer for many valuable comments and suggestions.  Excellent
research assistance from Irina Simankova is gratefully acknowledged.


{title:Authors}

{pstd}
Michael Oberfichtner{break}
Institute for Employment Research (IAB){break}
N{c u:}rnberg, Germany{break}
Michael.Oberfichtner2@iab.de{p_end}

{pstd}
Harald Tauchmann{break}
University of Erlangen-Nuremberg (FAU),{break}
and RWI -- Leibniz Institut f{c u:}r Wirtschaftsforschung,{break}
and CINCH -- Health Economics Research Center{break}
N{c u:}rnberg, Germany{break}
harald.tauchmann@fau.de


{title:Also see}

{p 4 14 2}
Article:  {it:Stata Journal}, volume 21, number 2: {browse "https://doi.org/10.1177/1536867X211025801":st0641}{p_end}

{p 5 14 2}
Manual:  {manlink R suest}, {manlink MV mvreg}, {manlink R test},
{manlink R areg}, {manlink R cnsreg}, {manlink R sureg}, {manlink XT xtset}

{p 7 14 2}
Help:  {manhelp suest R:suest}, {manhelp mvreg MV:mvreg},
{manhelp test R:test}, {manhelp areg R:areg}, {manhelp cnsreg R:cnsreg},
{manhelp sureg R:sureg}, {manhelp xtset XT:xtset}, {helpb cgmreg:cgmreg},
{helpb sreshape:sreshape} (if installed){p_end}
