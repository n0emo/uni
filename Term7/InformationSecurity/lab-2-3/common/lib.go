package common

import (
	"encoding/binary"
	"errors"
	"hash/adler32"
	"io"
)

var IV = []byte("J55NceZ0ST1sNfQ5")
var ByteOrder = binary.LittleEndian
var RsaHash = adler32.New()

const RsaKeySize = 4096

var SymmetricKeyLabel = []byte("symmetric key")

type Header struct {
	Len uint32
}

func WriteMessage(writer io.Writer, msg []byte) error {
	header := Header{Len: uint32(len(msg))}
	err := binary.Write(writer, ByteOrder, header)
	if err != nil {
		return err
	}

	totalWritten := 0
	for {
		n, err := writer.Write(msg[totalWritten:])
		if err != nil {
			return err
		}
		if n == 0 {
			return errors.New("EOF")
		}

		totalWritten += n

		if totalWritten >= n {
			break
		}
	}

	return nil
}

func ReadMessage(reader io.Reader) ([]byte, error) {
	header := Header{}
	err := binary.Read(reader, ByteOrder, &header)
	if err != nil {
		return nil, err
	}

	buf := make([]byte, header.Len)
	totalRead := 0

	for {
		n, err := reader.Read(buf[totalRead:])
		if err != nil {
			return nil, err
		}
		if n == 0 {
			return nil, errors.New("EOF")
		}
		totalRead += n
		if totalRead >= int(header.Len) {
			break
		}
	}

	return buf, nil
}
