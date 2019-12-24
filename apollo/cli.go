package main

import (
	"encoding/json"
	"fmt"

	agollo "github.com/philchia/agollo/v3"
)

func main() {
	agollo.Start()

	v := agollo.GetStringValue("timeout", "0")
	fmt.Println(v)

	ns := "application"
	c := agollo.GetNameSpaceContent(ns, "namespace file contents")
	fmt.Println(c)

	keys := agollo.GetAllKeys(ns)
	fmt.Println(keys)

	for {
		events := agollo.WatchUpdate()
		changeEvent := <-events
		bytes, _ := json.Marshal(changeEvent)
		fmt.Println("event:", string(bytes))
	}
}
