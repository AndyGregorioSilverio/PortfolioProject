# In this example I will be using Smoking data set to 
# show regressional analysis of probabilities of smoker behavior 
# based on a smoking ban


Smoking <- read.csv('Smoking.csv')

View(Smoking)



# probability of smoking for

# i. all workers

prob_all_workers <- mean(Smoking$smoker, na.rm = TRUE)

prob_all_workers

# ii. workers affected by workplace smoking bans

prob_smoking_ban <- mean(Smoking$smoker[Smoking$smkban == 1], na.rm = TRUE)

prob_smoking_ban

# iii. workers not affected by ban

prob_smoking_no_ban <- mean(Smoking$smoker[Smoking$smkban == 0], na.rm = TRUE)

prob_smoking_no_ban



# difference between prob in ban and no ban

diff <- prob_smoking_ban - prob_smoking_no_ban

diff

linear_reg <- lm(smoker ~ smkban, data = Smoking)
summary(linear_reg)


# linear probability model regression smoker y = regressors

reg <- lm(smoker ~ smkban + female + age + I(age^2) +
                 hsdrop + hsgrad + colsome + colgrad + black + hispanic,
                , data = Smoking)

summary(reg)



# testing hypothesis coeff smkban is zero
smkban_coeff <- reg$coefficients['smkban', 'Estimate']
smkban_se <- reg$coefficients['smkban', 'Std. Error']

t_test <- smkban_coeff/smkban_se

t_test # it is stat significant


# joint significance smk does not depend on education

install.packages("car")
library(car)

# Run the hypothesis test with correctly specified variable names
lm_testing<- linearHypothesis(reg, c("hsdrop = 0", "hsgrad = 0", "colsome = 0", "colgrad = 0"))
lm_testing


# nonlinear relationship between age and probability of smoking

# Create a new data frame for prediction
age_seq <- seq(min(Smoking$age, na.rm = TRUE), max(Smoking$age, na.rm = TRUE), by = 1)

# Setting the 0 equal to 1 if its true in context 
# of age and probability of smoking
predict_data <- data.frame(
  smkban = 0,  
  age = age_seq,
  `I(age^2)` = age_seq^2,
  hsdrop = 0,
  hsgrad = 0, 
  colsome = 0,
  colgrad = 0,
  black = 0,
  hispanic = 0,
  female = 0 
)

# Predict probabilities
predicted_probs <- predict(reg, newdata = predict_data, type = "response")


# Plot
par(mfrow=c(1,1))
plot(age_seq, predicted_probs, type = "l", col = "black",
     xlab = "Age (years)", ylab = "Probability of Smoking",
     main = "Predicted Probability of Smoking by Age",
     lwd = 2)



# probit
probit_reg <- glm(smoker ~ smkban + female + age + I(age^2) +
                  hsdrop + hsgrad + colsome + colgrad + black + hispanic,
                family = binomial(link = 'probit'), data = Smoking)

summary(probit_reg)

#testing

pro_bit_testing<- linearHypothesis(probit_reg, c("hsdrop = 0", "hsgrad = 0", "colsome = 0", "colgrad = 0"))
pro_bit_testing

stargazer(pro_bit_testing, type = 'html', out = 'probitFtest.html')

# logit

logit_reg <- glm(smoker ~ smkban + female + age + I(age^2) +
                   hsdrop + hsgrad + colsome + colgrad + black + hispanic,
                 family = binomial(link = 'logit'), data = Smoking)

summary(logit_reg)


log_it_testing<- linearHypothesis(logit_reg, c("hsdrop = 0", "hsgrad = 0", "colsome = 0", "colgrad = 0"))
log_it_testing







