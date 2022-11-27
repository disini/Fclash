package main

import "C"
import (
	"encoding/json"
	"fmt"
	"strconv"
	"unsafe"

	"os"

	"github.com/Dreamacro/clash/config"
	"github.com/Dreamacro/clash/constant"
	"github.com/Dreamacro/clash/hub"
	"github.com/Dreamacro/clash/hub/executor"
	"github.com/Dreamacro/clash/log"
	"github.com/Dreamacro/clash/tunnel/statistic"
	fclashgobridge "github.com/kingtous/fclash-go-bridge"
)

var (
	options []hub.Option
)

//export clash_init
func clash_init(home_dir *C.char) int {
	home := C.GoString(home_dir)
	// constant.
	err := config.Init(home)
	if err != nil {
		return -1
	}
	return 0
}

//export set_config
func set_config(config_path *C.char) int {
	file := C.GoString(config_path)
	if _, err := executor.ParseWithPath(file); err != nil {
		fmt.Printf("config validate failed: %s", err)
		return -1
	}
	constant.SetConfig(file)
	return 0
}

//export set_home_dir
func set_home_dir(home *C.char) int {
	home_gostr := C.GoString(home)
	info, err := os.Stat(home_gostr)
	if err == nil && info.IsDir() {
		fmt.Println("GO: set home dir to %s", home_gostr)
		constant.SetHomeDir(home_gostr)
		return 0
	} else {
		if err != nil {
			fmt.Println("error: %s", err)
		}
	}
	return -1
}

//export get_config
func get_config() *C.char {
	return C.CString(constant.Path.Config())
}

//export set_ext_controller
func set_ext_controller(port uint64) int {
	url := "127.0.0.1:" + strconv.FormatUint(port, 10)
	options = append(options, hub.WithExternalController(url))
	return 0
}

//export clear_ext_options
func clear_ext_options() {
	options = options[:0]
}

//export is_config_valid
func is_config_valid(config_path *C.char) int {
	if _, err := executor.ParseWithPath(C.GoString(config_path)); err != nil {
		fmt.Println("error reading config: %s", err)
		return -1
	}
	return 0
}

//export get_all_connections
func get_all_connections() *C.char {
	snapshot := statistic.DefaultManager.Snapshot()
	data, err := json.Marshal(snapshot)
	if err != nil {
		fmt.Println("Error: %s", err)
		return C.CString("")
	}
	return C.CString(string(data))
}

//export close_all_connections
func close_all_connections() {
	for _, connection := range statistic.DefaultManager.Snapshot().Connections {
		err := connection.Close()
		if err != nil {
			fmt.Println("warning: %s", err)
		}
	}
}

//export close_connection
func close_connection(id *C.char) bool {
	connection_id := C.GoString(id)
	for _, connection := range statistic.DefaultManager.Snapshot().Connections {
		if connection.ID() == connection_id {
			err := connection.Close()
			if err != nil {
				fmt.Println("warning: %s", err)
			}
			return true
		}
	}
	return false
}

//export parse_options
func parse_options() bool {
	err := hub.Parse(options...)
	if err != nil {
		return true
	}
	return false
}

//export get_traffic
func get_traffic() *C.char {
	up, down := statistic.DefaultManager.Now()
	traffic := map[string]int64{
		"Up":   up,
		"Down": down,
	}
	data, err := json.Marshal(traffic)
	if err != nil {
		fmt.Println("Error: %s", err)
		return C.CString("")
	}
	return C.CString(string(data))
}

//export init_native_api_bridge
func init_native_api_bridge(api unsafe.Pointer) {
	fclashgobridge.InitDartApi(api)
}

//export start_log
func start_log(port C.long) {
	subscibe := log.Subscribe()
	go func() {
		for elem := range subscibe {
			lg := elem.(log.Event)
			data, err := json.Marshal(lg)
			if err != nil {
				fmt.Errorf("Error: %s", err)
			}
			ret_str := string(data)
			fclashgobridge.SendToPort(int64(port), ret_str)
		}
	}()
	fmt.Println("[GO] subscribe logger on dart bridge port %s", int64(port))
}

func main() {
	fmt.Println("hello clash")
	// in := make(chan constant.ConnContext, 100)
	// defer close(in)

	// _, err := socks.New("127.0.0.1:8000", in)

	// if err != nil {
	// 	panic(err)
	// }

	// direct := outbound.New

}
