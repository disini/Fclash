module github.com/kingtous/flutter-clash-binding

go 1.21

// toolchain go1.21.0

replace github.com/kingtous/fclash-go-bridge => ./fclash-go-bridge

require (
	github.com/kingtous/fclash-go-bridge v1.0.0
	github.com/metacubex/mihomo v1.18.1
)

require gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c // indirect

require (
	github.com/3andne/restls-client-go v0.1.6 // indirect
	github.com/RyuaNerin/go-krypto v1.2.4 // indirect
	github.com/Yawning/aez v0.0.0-20211027044916-e49e68abd344 // indirect
	github.com/aead/chacha20 v0.0.0-20180709150244-8b13a72661da // indirect
	github.com/ajg/form v1.5.1 // indirect
	github.com/andybalholm/brotli v1.1.0 // indirect
	github.com/bahlo/generic-list-go v0.2.0 // indirect
	github.com/buger/jsonparser v1.1.1 // indirect
	github.com/cilium/ebpf v0.12.3 // indirect
	github.com/cloudflare/circl v1.3.7 // indirect
	github.com/coreos/go-iptables v0.7.0 // indirect
	github.com/dlclark/regexp2 v1.10.0 // indirect
	github.com/ericlagergren/aegis v0.0.0-20230312195928-b4ce538b56f9 // indirect
	github.com/ericlagergren/polyval v0.0.0-20230805202542-18692a1b76f9 // indirect
	github.com/ericlagergren/siv v0.0.0-20220507050439-0b757b3aa5f1 // indirect
	github.com/ericlagergren/subtle v0.0.0-20220507045147-890d697da010 // indirect
	github.com/fsnotify/fsnotify v1.7.0 // indirect
	github.com/gaukas/godicttls v0.0.4 // indirect
	github.com/go-chi/chi/v5 v5.0.11 // indirect
	github.com/go-chi/cors v1.2.1 // indirect
	github.com/go-chi/render v1.0.3 // indirect
	github.com/go-ole/go-ole v1.3.0 // indirect
	github.com/go-task/slim-sprig v0.0.0-20230315185526-52ccab3ef572 // indirect
	github.com/gobwas/httphead v0.1.0 // indirect
	github.com/gobwas/pool v0.2.1 // indirect
	github.com/gobwas/ws v1.3.2 // indirect
	github.com/gofrs/uuid/v5 v5.0.0 // indirect
	github.com/google/btree v1.1.2 // indirect
	github.com/google/go-cmp v0.6.0 // indirect
	github.com/google/pprof v0.0.0-20240207164012-fb44976bdcd5 // indirect
	github.com/hashicorp/yamux v0.1.1 // indirect
	github.com/insomniacslk/dhcp v0.0.0-20240204152450-ca2dc33955c1 // indirect
	github.com/josharian/native v1.1.0 // indirect
	github.com/jpillora/backoff v1.0.0 // indirect
	github.com/klauspost/compress v1.17.6 // indirect
	github.com/klauspost/cpuid/v2 v2.2.6 // indirect
	github.com/lufia/plan9stats v0.0.0-20231016141302-07b5767bb0ed // indirect
	github.com/lunixbochs/struc v0.0.0-20200707160740-784aaebc1d40 // indirect
	github.com/mailru/easyjson v0.7.7 // indirect
	github.com/mdlayher/netlink v1.7.2 // indirect
	github.com/mdlayher/socket v0.5.0 // indirect
	github.com/metacubex/gopacket v1.1.20-0.20230608035415-7e2f98a3e759 // indirect
	github.com/metacubex/gvisor v0.0.0-20231209122014-3e43224c7bbc // indirect
	github.com/metacubex/quic-go v0.41.1-0.20240120014142-a02f4a533d4a // indirect
	github.com/metacubex/sing-quic v0.0.0-20240130040922-cbe613c88f20 // indirect
	github.com/metacubex/sing-shadowsocks v0.2.6 // indirect
	github.com/metacubex/sing-shadowsocks2 v0.2.0 // indirect
	github.com/metacubex/sing-tun v0.2.1-0.20240130042529-1f983547e9d4 // indirect
	github.com/metacubex/sing-vmess v0.1.9-0.20231207122118-72303677451f // indirect
	github.com/metacubex/sing-wireguard v0.0.0-20231209125515-0594297f7232 // indirect
	github.com/miekg/dns v1.1.58 // indirect
	github.com/mroth/weightedrand/v2 v2.1.0 // indirect
	github.com/oasisprotocol/deoxysii v0.0.0-20220228165953-2091330c22b7 // indirect
	github.com/onsi/ginkgo/v2 v2.15.0 // indirect
	github.com/openacid/low v0.1.21 // indirect
	github.com/oschwald/maxminddb-golang v1.12.0 // indirect
	github.com/pierrec/lz4/v4 v4.1.21 // indirect
	github.com/power-devops/perfstat v0.0.0-20221212215047-62379fc7944b // indirect
	github.com/puzpuzpuz/xsync/v3 v3.0.2 // indirect
	github.com/quic-go/qpack v0.4.0 // indirect
	github.com/quic-go/qtls-go1-20 v0.4.1 // indirect
	github.com/sagernet/bbolt v0.0.0-20231014093535-ea5cb2fe9f0a // indirect
	github.com/sagernet/netlink v0.0.0-20220905062125-8043b4a9aa97 // indirect
	github.com/sagernet/sing v0.3.0 // indirect
	github.com/sagernet/sing-mux v0.2.1-0.20240124034317-9bfb33698bb6 // indirect
	github.com/sagernet/sing-shadowtls v0.1.4 // indirect
	github.com/sagernet/smux v0.0.0-20231208180855-7041f6ea79e7 // indirect
	github.com/sagernet/tfo-go v0.0.0-20231209031829-7b5343ac1dc6 // indirect
	github.com/sagernet/utls v1.5.4 // indirect
	github.com/sagernet/wireguard-go v0.0.0-20231209092712-9a439356a62e // indirect
	github.com/samber/lo v1.39.0 // indirect
	github.com/scjalliance/comshim v0.0.0-20231116235529-bbacf79a4691 // indirect
	github.com/shirou/gopsutil/v3 v3.24.1 // indirect
	github.com/shoenig/go-m1cpu v0.1.6 // indirect
	github.com/sina-ghaderi/poly1305 v0.0.0-20220724002748-c5926b03988b // indirect
	github.com/sina-ghaderi/rabaead v0.0.0-20220730151906-ab6e06b96e8c // indirect
	github.com/sina-ghaderi/rabbitio v0.0.0-20220730151941-9ce26f4f872e // indirect
	github.com/sirupsen/logrus v1.9.3 // indirect
	github.com/tklauser/go-sysconf v0.3.13 // indirect
	github.com/tklauser/numcpus v0.7.0 // indirect
	github.com/u-root/uio v0.0.0-20240209044354-b3d14b93376a // indirect
	github.com/vishvananda/netns v0.0.4 // indirect
	github.com/wk8/go-ordered-map/v2 v2.1.8 // indirect
	github.com/yusufpapurcu/wmi v1.2.4 // indirect
	github.com/zhangyunhao116/fastrand v0.3.0 // indirect
	gitlab.com/yawning/bsaes.git v0.0.0-20190805113838-0a714cd429ec // indirect
	go.uber.org/mock v0.4.0 // indirect
	go4.org/netipx v0.0.0-20231129151722-fdeea329fbba // indirect
	golang.org/x/crypto v0.19.0 // indirect
	golang.org/x/exp v0.0.0-20240205201215-2c58cdc269a3 // indirect
	golang.org/x/mod v0.15.0 // indirect
	golang.org/x/net v0.21.0 // indirect
	golang.org/x/sync v0.6.0 // indirect
	golang.org/x/sys v0.17.0 // indirect
	golang.org/x/text v0.14.0 // indirect
	golang.org/x/time v0.5.0 // indirect
	golang.org/x/tools v0.17.0 // indirect
	google.golang.org/protobuf v1.32.0 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
	lukechampine.com/blake3 v1.2.1 // indirect
)
