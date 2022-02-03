# Vending Machine

## How to run
`docker build -t vm . && docker run -it vm`

## How to run single test
`docker build -t vm . && docker run vm bundle exec rspec spec/inventory_spec.rb`

## How to run all tests
`docker build -t vm . && docker run vm bundle exec rspec --pattern="spec/*.rb"`

## How to get shell session in container
`docker build -t vm . && docker run -it vm sh`
