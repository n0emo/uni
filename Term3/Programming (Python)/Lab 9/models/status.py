from enum import IntEnum


class StatusCode(IntEnum):
    OK = 200
    CREATED = 201
    UNAUTHORIZED = 401
    FORBIDDEN = 403
    CONFLICT = 409
    INTERNAL_ERROR = 502
