% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LearnerClassifGlmnet.R
\name{mlr_learners_classif.glmnet}
\alias{mlr_learners_classif.glmnet}
\alias{LearnerClassifGlmnet}
\title{GLM with Elastic Net Regularization Classification Learner}
\description{
Generalized linear models with elastic net regularization.
Calls \code{\link[glmnet:glmnet]{glmnet::glmnet()}} from package \CRANpkg{glmnet}.
}
\details{
Caution: This learner is different to learners calling \code{\link[glmnet:cv.glmnet]{glmnet::cv.glmnet()}}
in that it does not use the internal optimization of parameter \code{lambda}.
Instead, \code{lambda} needs to be tuned by the user (e.g., via \CRANpkg{mlr3tuning}).
When \code{lambda} is tuned, the \code{glmnet} will be trained for each tuning iteration.
While fitting the whole path of \code{lambda}s would be more efficient, as is done
by default in \code{\link[glmnet:glmnet]{glmnet::glmnet()}}, tuning/selecting the parameter at prediction time
(using parameter \code{s}) is currently not supported in \CRANpkg{mlr3}
(at least not in efficient manner).
Tuning the \code{s} parameter is, therefore, currently discouraged.

When the data are i.i.d. and efficiency is key, we recommend using the respective
auto-tuning counterparts in \code{\link[=mlr_learners_classif.cv_glmnet]{mlr_learners_classif.cv_glmnet()}} or
\code{\link[=mlr_learners_regr.cv_glmnet]{mlr_learners_regr.cv_glmnet()}}.
However, in some situations this is not applicable, usually when data are
imbalanced or not i.i.d. (longitudinal, time-series) and tuning requires
custom resampling strategies (blocked design, stratification).
}
\section{Dictionary}{

This \link[mlr3:Learner]{mlr3::Learner} can be instantiated via the \link[mlr3misc:Dictionary]{dictionary} \link[mlr3:mlr_learners]{mlr3::mlr_learners} or with the associated sugar function \code{\link[mlr3:mlr_sugar]{mlr3::lrn()}}:

\if{html}{\out{<div class="sourceCode">}}\preformatted{mlr_learners$get("classif.glmnet")
lrn("classif.glmnet")
}\if{html}{\out{</div>}}
}

\section{Meta Information}{

\itemize{
\item Task type: \dQuote{classif}
\item Predict Types: \dQuote{response}, \dQuote{prob}
\item Feature Types: \dQuote{logical}, \dQuote{integer}, \dQuote{numeric}
\item Required Packages: \CRANpkg{mlr3}, \CRANpkg{mlr3learners}, \CRANpkg{glmnet}
}
}

\section{Parameters}{
\tabular{lllll}{
   Id \tab Type \tab Default \tab Levels \tab Range \cr
   alpha \tab numeric \tab 1 \tab  \tab \eqn{[0, 1]}{[0, 1]} \cr
   big \tab numeric \tab 9.9e+35 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   devmax \tab numeric \tab 0.999 \tab  \tab \eqn{[0, 1]}{[0, 1]} \cr
   dfmax \tab integer \tab - \tab  \tab \eqn{[0, \infty)}{[0, Inf)} \cr
   eps \tab numeric \tab 1e-06 \tab  \tab \eqn{[0, 1]}{[0, 1]} \cr
   epsnr \tab numeric \tab 1e-08 \tab  \tab \eqn{[0, 1]}{[0, 1]} \cr
   exact \tab logical \tab FALSE \tab TRUE, FALSE \tab - \cr
   exclude \tab integer \tab - \tab  \tab \eqn{[1, \infty)}{[1, Inf)} \cr
   exmx \tab numeric \tab 250 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   fdev \tab numeric \tab 1e-05 \tab  \tab \eqn{[0, 1]}{[0, 1]} \cr
   gamma \tab numeric \tab 1 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   intercept \tab logical \tab TRUE \tab TRUE, FALSE \tab - \cr
   lambda \tab untyped \tab - \tab  \tab - \cr
   lambda.min.ratio \tab numeric \tab - \tab  \tab \eqn{[0, 1]}{[0, 1]} \cr
   lower.limits \tab untyped \tab - \tab  \tab - \cr
   maxit \tab integer \tab 100000 \tab  \tab \eqn{[1, \infty)}{[1, Inf)} \cr
   mnlam \tab integer \tab 5 \tab  \tab \eqn{[1, \infty)}{[1, Inf)} \cr
   mxit \tab integer \tab 100 \tab  \tab \eqn{[1, \infty)}{[1, Inf)} \cr
   mxitnr \tab integer \tab 25 \tab  \tab \eqn{[1, \infty)}{[1, Inf)} \cr
   nlambda \tab integer \tab 100 \tab  \tab \eqn{[1, \infty)}{[1, Inf)} \cr
   use_pred_offset \tab logical \tab TRUE \tab TRUE, FALSE \tab - \cr
   penalty.factor \tab untyped \tab - \tab  \tab - \cr
   pmax \tab integer \tab - \tab  \tab \eqn{[0, \infty)}{[0, Inf)} \cr
   pmin \tab numeric \tab 1e-09 \tab  \tab \eqn{[0, 1]}{[0, 1]} \cr
   prec \tab numeric \tab 1e-10 \tab  \tab \eqn{(-\infty, \infty)}{(-Inf, Inf)} \cr
   relax \tab logical \tab FALSE \tab TRUE, FALSE \tab - \cr
   s \tab numeric \tab 0.01 \tab  \tab \eqn{[0, \infty)}{[0, Inf)} \cr
   standardize \tab logical \tab TRUE \tab TRUE, FALSE \tab - \cr
   standardize.response \tab logical \tab FALSE \tab TRUE, FALSE \tab - \cr
   thresh \tab numeric \tab 1e-07 \tab  \tab \eqn{[0, \infty)}{[0, Inf)} \cr
   trace.it \tab integer \tab 0 \tab  \tab \eqn{[0, 1]}{[0, 1]} \cr
   type.gaussian \tab character \tab - \tab covariance, naive \tab - \cr
   type.logistic \tab character \tab - \tab Newton, modified.Newton \tab - \cr
   type.multinomial \tab character \tab - \tab ungrouped, grouped \tab - \cr
   upper.limits \tab untyped \tab - \tab  \tab - \cr
}
}

\section{Internal Encoding}{

Starting with \CRANpkg{mlr3} v0.5.0, the order of class labels is reversed prior to
model fitting to comply to the \code{\link[stats:glm]{stats::glm()}} convention that the negative class is provided
as the first factor level.
}

\section{Offset}{

If a \code{Task} contains a column with the \code{offset} role, it is automatically incorporated during training via the \code{offset} argument in \code{\link[glmnet:glmnet]{glmnet::glmnet()}}.
During prediction, the offset column from the test set is used only if \code{use_pred_offset = TRUE} (default), passed via the \code{newoffset} argument in \code{\link[glmnet:predict.glmnet]{glmnet::predict.glmnet()}}.
Otherwise, if the user sets \code{use_pred_offset = FALSE}, a zero offset is applied, effectively disabling the offset adjustment during prediction.
}

\examples{
if (requireNamespace("glmnet", quietly = TRUE)) {
# Define the Learner and set parameter values
learner = lrn("classif.glmnet")
print(learner)

# Define a Task
task = tsk("sonar")

# Create train and test set
ids = partition(task)

# Train the learner on the training ids
learner$train(task, row_ids = ids$train)

# print the model
print(learner$model)

# importance method
if("importance" \%in\% learner$properties) print(learner$importance)

# Make predictions for the test rows
predictions = learner$predict(task, row_ids = ids$test)

# Score the predictions
predictions$score()
}
}
\references{
Friedman J, Hastie T, Tibshirani R (2010).
\dQuote{Regularization Paths for Generalized Linear Models via Coordinate Descent.}
\emph{Journal of Statistical Software}, \bold{33}(1), 1--22.
\doi{10.18637/jss.v033.i01}.
}
\seealso{
\itemize{
\item Chapter in the \href{https://mlr3book.mlr-org.com/}{mlr3book}:
\url{https://mlr3book.mlr-org.com/chapters/chapter2/data_and_basic_modeling.html#sec-learners}
\item Package \href{https://github.com/mlr-org/mlr3extralearners}{mlr3extralearners} for more learners.
\item \link[mlr3misc:Dictionary]{Dictionary} of \link[mlr3:Learner]{Learners}: \link[mlr3:mlr_learners]{mlr3::mlr_learners}
\item \code{as.data.table(mlr_learners)} for a table of available \link[mlr3:Learner]{Learners} in the running session (depending on the loaded packages).
\item \CRANpkg{mlr3pipelines} to combine learners with pre- and postprocessing steps.
\item Extension packages for additional task types:
\itemize{
\item \CRANpkg{mlr3proba} for probabilistic supervised regression and survival analysis.
\item \CRANpkg{mlr3cluster} for unsupervised clustering.
}
\item \CRANpkg{mlr3tuning} for tuning of hyperparameters, \CRANpkg{mlr3tuningspaces}
for established default tuning spaces.
}

Other Learner: 
\code{\link{mlr_learners_classif.cv_glmnet}},
\code{\link{mlr_learners_classif.kknn}},
\code{\link{mlr_learners_classif.lda}},
\code{\link{mlr_learners_classif.log_reg}},
\code{\link{mlr_learners_classif.multinom}},
\code{\link{mlr_learners_classif.naive_bayes}},
\code{\link{mlr_learners_classif.nnet}},
\code{\link{mlr_learners_classif.qda}},
\code{\link{mlr_learners_classif.ranger}},
\code{\link{mlr_learners_classif.svm}},
\code{\link{mlr_learners_classif.xgboost}},
\code{\link{mlr_learners_regr.cv_glmnet}},
\code{\link{mlr_learners_regr.glmnet}},
\code{\link{mlr_learners_regr.kknn}},
\code{\link{mlr_learners_regr.km}},
\code{\link{mlr_learners_regr.lm}},
\code{\link{mlr_learners_regr.nnet}},
\code{\link{mlr_learners_regr.ranger}},
\code{\link{mlr_learners_regr.svm}},
\code{\link{mlr_learners_regr.xgboost}}
}
\concept{Learner}
\section{Super classes}{
\code{\link[mlr3:Learner]{mlr3::Learner}} -> \code{\link[mlr3:LearnerClassif]{mlr3::LearnerClassif}} -> \code{LearnerClassifGlmnet}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-LearnerClassifGlmnet-new}{\code{LearnerClassifGlmnet$new()}}
\item \href{#method-LearnerClassifGlmnet-selected_features}{\code{LearnerClassifGlmnet$selected_features()}}
\item \href{#method-LearnerClassifGlmnet-clone}{\code{LearnerClassifGlmnet$clone()}}
}
}
\if{html}{\out{
<details><summary>Inherited methods</summary>
<ul>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="base_learner"><a href='../../mlr3/html/Learner.html#method-Learner-base_learner'><code>mlr3::Learner$base_learner()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="configure"><a href='../../mlr3/html/Learner.html#method-Learner-configure'><code>mlr3::Learner$configure()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="encapsulate"><a href='../../mlr3/html/Learner.html#method-Learner-encapsulate'><code>mlr3::Learner$encapsulate()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="format"><a href='../../mlr3/html/Learner.html#method-Learner-format'><code>mlr3::Learner$format()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="help"><a href='../../mlr3/html/Learner.html#method-Learner-help'><code>mlr3::Learner$help()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="predict"><a href='../../mlr3/html/Learner.html#method-Learner-predict'><code>mlr3::Learner$predict()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="predict_newdata"><a href='../../mlr3/html/Learner.html#method-Learner-predict_newdata'><code>mlr3::Learner$predict_newdata()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="print"><a href='../../mlr3/html/Learner.html#method-Learner-print'><code>mlr3::Learner$print()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="reset"><a href='../../mlr3/html/Learner.html#method-Learner-reset'><code>mlr3::Learner$reset()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Learner" data-id="train"><a href='../../mlr3/html/Learner.html#method-Learner-train'><code>mlr3::Learner$train()</code></a></span></li>
</ul>
</details>
}}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-LearnerClassifGlmnet-new"></a>}}
\if{latex}{\out{\hypertarget{method-LearnerClassifGlmnet-new}{}}}
\subsection{Method \code{new()}}{
Creates a new instance of this \link[R6:R6Class]{R6} class.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{LearnerClassifGlmnet$new()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-LearnerClassifGlmnet-selected_features"></a>}}
\if{latex}{\out{\hypertarget{method-LearnerClassifGlmnet-selected_features}{}}}
\subsection{Method \code{selected_features()}}{
Returns the set of selected features as reported by \code{\link[glmnet:predict.glmnet]{glmnet::predict.glmnet()}}
with \code{type} set to \code{"nonzero"}.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{LearnerClassifGlmnet$selected_features(lambda = NULL)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{lambda}}{(\code{numeric(1)})\cr
Custom \code{lambda}, defaults to the active lambda depending on parameter set.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
(\code{character()}) of feature names.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-LearnerClassifGlmnet-clone"></a>}}
\if{latex}{\out{\hypertarget{method-LearnerClassifGlmnet-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{LearnerClassifGlmnet$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
