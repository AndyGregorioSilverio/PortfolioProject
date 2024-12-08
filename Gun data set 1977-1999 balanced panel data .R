#In this example, I use a data set from "shooting down the 'more guns less crime'
#to do regressional analysis

guns <- read.csv('Guns.csv')
View(guns)


#A regression of ln(vio) on shall

guns$lvio <- log(guns$vio)

reg_lvio <- lm(lvio ~ shall, data = guns)
summary(reg_lvio)

# now ln(vio) on shall, incarca_rate, avginc, pop, pb1064, pw1064, pm1029

reg_lvio_multi <- lm(lvio ~ shall + incarc_rate + density + avginc + pop +
                       pb1064 + pw1064 + pm1029 , data = guns)

summary(reg_lvio_multi)

# the estimate is 36 percent decrease in violent crimes which is large

# do results change when adding fixed state effects?

library(plm)

fixed_state_reg <- plm(lvio ~ shall + incarc_rate + density + avginc + pop +
                          pb1064 + pw1064 + pm1029 , data = guns,
                        index = c('stateid', 'year'),
                        model = 'within')

summary(fixed_state_reg)


# do results change when adding fixed time effect?


fixed_reg <- plm(
  lvio ~ shall + incarc_rate + density + avginc + pop +
    pb1064 + pw1064 + pm1029 + factor(year) ,
  data = guns,
  index = c('stateid', 'year'),
  model = 'within',
  effect = 'twoways'
)

summary(fixed_reg)

#shall is not statistically significant with vio rate

#repeat analysis using inrob and lnmur instead of lnvio

#(i). lnrob

guns$lrob <- log(guns$rob)

reg_lrob_single <- lm(lrob ~ shall, data = guns)
summary(reg_lrob_single)

reg_lrob_multi <- lm(lrob ~ shall + incarc_rate + density + avginc + pop +
                       pb1064 + pw1064 + pm1029 , data = guns)
summary(reg_lrob_multi)

fixed_state_rob <-  plm(lrob ~ shall + incarc_rate + density + avginc + pop +
                          pb1064 + pw1064 + pm1029 , data = guns,
                        index = c('stateid', 'year'),
                        model = 'within')
summary(fixed_state_rob)



total_fixed_lrob <- plm(lrob ~ shall + incarc_rate + density + avginc + pop +
                          pb1064 + pw1064 + pm1029 + factor(year) , data = guns,
                        index = c('stateid', 'year'),
                        model = 'within',
                        effect = 'twoways')

summary(total_fixed_lrob)

#shall is not statistically significant with rob rate

#(ii). lnmur
guns$lmur <- log(guns$mur)

reg_lmur_single <- lm(lmur ~ shall, data = guns)

summary(reg_lmur_single)

reg_lmur_multi <- lm(lmur ~ shall + incarc_rate + density + avginc + pop +
                       pb1064 + pw1064 + pm1029 , data = guns)
summary(reg_lmur_multi)

fixed_state_mur <-  plm(lmur ~ shall + incarc_rate + density + avginc + pop +
                                             pb1064 + pw1064 + pm1029 , data = guns,
                                           index = c('stateid', 'year'),
                                           model = 'within')
summary(fixed_state_mur)


total_fixed_lmur <- plm(lmur ~ shall + incarc_rate + density + avginc + pop +
                                       pb1064 + pw1064 + pm1029 + factor(year) , data = guns,
                                     index = c('stateid', 'year'),
                                     model = 'within',
                                      effect ='twoways')

summary(total_fixed_lmur)

#shall is not statistically significant with mur rate





