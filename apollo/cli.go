package main

import (
	"fmt"
	"os"

	"github.com/shima-park/agollo"
)

func main() {
	err := agollo.InitWithDefaultConfigFile(
		agollo.WithLogger(agollo.NewLogger(agollo.LoggerWriter(os.Stdout))),
		agollo.PreloadNamespaces("application"),
		agollo.AutoFetchOnCacheMiss(),
		agollo.FailTolerantOnBackupExists(),
	)
	if err != nil {
		panic(err)
	}

	fmt.Println("timeout:", agollo.Get("timeout"))

	fmt.Println(agollo.GetNameSpace("application"))

	errorCh := agollo.Start()
	watchCh := agollo.Watch()

	stop := make(chan bool)
	watchNamespace := "application"
	watchNSCh := agollo.WatchNamespace(watchNamespace, stop)

	go func() {
		for {
			select {
			case err := <-errorCh:
				fmt.Println("Error:", err)
			case resp := <-watchCh:
				fmt.Printf("Watch Apollo: %+v\n", resp)
			case resp := <-watchNSCh:
				fmt.Println("Watch Namespace", watchNamespace, resp)
			}
		}
	}()

	select {}

	agollo.Stop()
}
