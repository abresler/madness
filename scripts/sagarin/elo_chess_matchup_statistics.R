# Create matchup statistics for elo_chess
model = "elo_chess"

source("matchup_statistics.R")

probs = 
  ldply(mcmc, function(x) {
    season = attr(x,"name")
    theta  = extract(x, "theta")[[1]]
    
    sub = submission[submission$season==season,]
    n   = nrow(sub)
    
    prob = numeric(n)
    for (i in 1:n) {
      prob[i] = mean(pnorm(theta[,sub$my_lowerid[i]]-theta[,sub$my_upperid[i]]))
    }
    
    data.frame(lowerid = sub$lowerid,
               upperid = sub$upperid,
               pred = prob)
  })

source("matchup_statistics_write.R")
