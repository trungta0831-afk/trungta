#!/bin/sh

#
# Bản quyền © 2015 thuộc về các tác giả gốc.
#
# Được cấp phép theo Giấy phép Apache, Phiên bản 2.0 ("Giấy phép");
Bạn không được phép sử dụng tệp này trừ khi tuân thủ Giấy phép.
Bạn có thể nhận được bản sao Giấy phép tại đây.
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Trừ khi luật pháp hiện hành yêu cầu hoặc có thỏa thuận bằng văn bản, phần mềm
# Được phân phối theo Giấy phép này trên cơ sở "NGUYÊN TRẠNG".
# KHÔNG CÓ BẢO ĐẢM HOẶC ĐIỀU KIỆN NÀO, dù rõ ràng hay ngầm định.
# Xem Giấy phép để biết các điều khoản cụ thể về quyền hạn và ngôn ngữ quản lý.
# Các hạn chế theo Giấy phép.
#
# SPDX-License-Identifier: Apache-2.0
#

##############################################################################
#
# Tập lệnh khởi động gradlew cho POSIX được tạo bởi Gradle.
#
# Quan trọng đối với quá trình chạy:
#
# (1) Bạn cần một shell tuân thủ POSIX để chạy tập lệnh này. Nếu /bin/sh của bạn là
# không tuân thủ, nhưng bạn có một trình shell tuân thủ khác như ksh hoặc
# bash, sau đó để chạy tập lệnh này, hãy gõ tên shell đó trước toàn bộ
# dòng lệnh, ví dụ:
#
# ksh gradlew
#
# Busybox và các shell rút gọn tương tự sẽ KHÔNG hoạt động, vì script này
# Yêu cầu tất cả các tính năng shell POSIX này:
# * hàm;
# * phần mở rộng «$var», «${var}», «${var:-default}», «${var+SET}»,
# «${var#prefix}», «${var%suffix}», và «$( cmd )»;
# * Các lệnh phức hợp có trạng thái thoát có thể kiểm tra được, đặc biệt là «case»;
# * Các lệnh tích hợp khác nhau bao gồm «command», «set» và «ulimit».
#
# Thông tin quan trọng cần lưu ý khi vá lỗi:
#
# (2) Tập lệnh này nhắm mục tiêu vào bất kỳ shell POSIX nào, do đó nó tránh các phần mở rộng được cung cấp
# Được thực hiện bởi Bash, Ksh, v.v.; đặc biệt là tránh sử dụng mảng.
#
# Cách làm "truyền thống" là đóng gói nhiều tham số vào một
# Chuỗi ký tự phân tách bằng dấu cách là một nguồn gây lỗi và vấn đề bảo mật đã được ghi nhận rõ ràng.
# vấn đề, vì vậy điều này (hầu hết) được tránh bằng cách tích lũy dần dần
# các tùy chọn trong "$@", và cuối cùng truyền chúng cho Java.
#
# Nơi các biến môi trường được kế thừa (DEFAULT_JVM_OPTS, JAVA_OPTS,
# và GRADLE_OPTS) dựa vào việc tách từ, việc này được thực hiện một cách rõ ràng;
# Xem phần chú thích ngay trong văn bản để biết thêm chi tiết.
#
# Có những tinh chỉnh dành riêng cho các hệ điều hành cụ thể như AIX, CygWin,
# Darwin, MinGW và NonStop.
#
# (3) Tập lệnh này được tạo từ mẫu Groovy
# https://github.com/gradle/gradle/blob/3d91ce3b8caaf77ad09f381f43615b715b53f72c/platforms/jvm/plugins-application/src/main/resources/org/gradle/api/internal/plugins/unixStartScript.txt
# bên trong dự án Gradle.
#
Bạn có thể tìm thấy Gradle tại https://github.com/gradle/gradle/.
#
##############################################################################

# Cố gắng thiết lập APP_HOME

# Giải quyết các liên kết: $0 có thể là một liên kết
app_path=$0

# Cần điều này cho các liên kết tượng trưng nối tiếp nhau.
trong khi
    APP_HOME=${app_path%"${app_path##*/}"} # để lại dấu / ở cuối; để trống nếu không có đường dẫn phía trước
    [ -h "$app_path" ]
LÀM
    ls=$( ls -ld "$app_path" )
    link=${ls#*' -> '}
    trường hợp $link trong #(
      /*) app_path=$link ;; #(
      *) app_path=$APP_HOME$link ;;
    esac
xong

# Thông thường, phần này không được sử dụng
# shellcheck disable=SC2034
APP_BASE_NAME=${0##*/}
# Loại bỏ đầu ra chuẩn của lệnh cd trong trường hợp biến môi trường $CDPATH được thiết lập (https://github.com/gradle/gradle/issues/25036)
APP_HOME=$( cd -P "${APP_HOME:-./}" > /dev/null && printf '%s\n' "$PWD" ) || exit

# Sử dụng giá trị tối đa có sẵn, hoặc đặt MAX_FD != -1 để sử dụng giá trị đó.
MAX_FD=tối đa

cảnh báo () {
    echo "$*"
} >&2

chết () {
    tiếng vọng
    echo "$*"
    tiếng vọng
    lối ra 1
} >&2

# Hỗ trợ dành riêng cho hệ điều hành (phải là 'true' hoặc 'false').
cygwin=false
msys=false
darwin=false
không ngừng=sai
trường hợp "$( uname )" trong #(
  CYGWIN* ) cygwin=true ;; #(
  Darwin* ) darwin=true ;; #(
  MSYS* | MINGW* ) msys=true ;; #(
  KHÔNG NGỪNG* ) không ngừng=true ;;
esac



# Xác định lệnh Java cần sử dụng để khởi động JVM.
nếu [ -n "$JAVA_HOME" ] ; thì
    nếu [ -x "$JAVA_HOME/jre/sh/java" ] ; thì
        # JDK của IBM trên AIX sử dụng các vị trí kỳ lạ cho các tệp thực thi
        JAVACMD=$JAVA_HOME/jre/sh/java
    khác
        JAVACMD=$JAVA_HOME/bin/java
    fi
    nếu [ ! -x "$JAVACMD" ] ; thì
        Lỗi: Biến môi trường JAVA_HOME được thiết lập thành thư mục không hợp lệ: $JAVA_HOME

Vui lòng thiết lập biến môi trường JAVA_HOME sao cho khớp với...
Vị trí cài đặt Java của bạn.
    fi
khác
    JAVACMD=java
    if ! command -v java >/dev/null 2>&1
    sau đó
        "LỖI: Biến môi trường JAVA_HOME chưa được thiết lập và không tìm thấy lệnh 'java' trong biến môi trường PATH của bạn."

Vui lòng thiết lập biến môi trường JAVA_HOME sao cho khớp với...
Vị trí cài đặt Java của bạn.
    fi
fi

# Tăng số lượng bộ mô tả tệp tối đa nếu có thể.
if ! "$cygwin" && ! "$darwin" && ! "$nonstop" ; then
    trường hợp $MAX_FD trong #(
      tối đa*)
        # Trong POSIX sh, ulimit -H không được định nghĩa. Đó là lý do tại sao kết quả được kiểm tra để xem nó có hoạt động hay không.
        # shellcheck disable=SC2039,SC3045
        MAX_FD=$( ulimit -H -n ) ||
            cảnh báo "Không thể truy vấn giới hạn mô tả tệp tối đa"
    esac
    trường hợp $MAX_FD trong #(
      '' | mềm) :;; #(
      *)
        # Trong POSIX sh, ulimit -n không được định nghĩa. Đó là lý do tại sao kết quả được kiểm tra để xem nó có hoạt động hay không.
        # shellcheck disable=SC2039,SC3045
        ulimit -n "$MAX_FD" ||
            cảnh báo "Không thể đặt giới hạn số mô tả tệp tối đa thành $MAX_FD"
    esac
fi

# Thu thập tất cả các đối số cho lệnh java, xếp chồng theo thứ tự ngược lại:
# * Các đối số từ dòng lệnh
# * tên lớp chính
# * -classpath
# * -D...cài đặt tên ứng dụng
# * --module-path (chỉ khi cần)
# * Các biến môi trường DEFAULT_JVM_OPTS, JAVA_OPTS và GRADLE_OPTS.

# Đối với Cygwin hoặc MSYS, hãy chuyển đổi đường dẫn sang định dạng Windows trước khi chạy Java
nếu "$cygwin" || "$msys" ; thì
    APP_HOME=$( cygpath --path --mixed "$APP_HOME" )

    JAVACMD=$( cygpath --unix "$JAVACMD" )

    # Bây giờ hãy chuyển đổi các đối số - một giải pháp tạm thời để giới hạn phạm vi chỉ sử dụng /bin/sh
    đối với đối số thực hiện
        nếu như
            trường hợp $arg trong #(
              -*) false ;; # đừng can thiệp vào các tùy chọn #(
              /?*) t=${arg#/} t=/${t%%/*} # trông giống như đường dẫn tệp POSIX
                    [ -e "$t" ] ;; #(
              *) SAI ;;
            esac
        sau đó
            arg=$( cygpath --path --ignore --mixed "$arg" )
        fi
        # Lặp lại danh sách đối số đúng số lần bằng số lượng
        # các đối số, vì vậy mỗi đối số sẽ quay trở lại vị trí ban đầu, nhưng
        # Có thể đã được chỉnh sửa.
        #
        # Lưu ý: vòng lặp `for` lưu trữ danh sách các phần tử cần lặp trước khi bắt đầu, vì vậy
        # Việc thay đổi các tham số vị trí ở đây không ảnh hưởng đến số lượng
        # số lần lặp, cũng không phải các giá trị được trình bày trong `arg`.
        shift # xóa đối số cũ
        đặt -- "$@" "$arg" # đẩy đối số thay thế
    xong
fi


# Thêm các tùy chọn JVM mặc định tại đây. Bạn cũng có thể sử dụng JAVA_OPTS và GRADLE_OPTS để truyền các tùy chọn JVM cho tập lệnh này.
DEFAULT_JVM_OPTS='-Dfile.encoding=UTF-8 "-Xmx64m" "-Xms64m"'

# Thu thập tất cả các đối số cho lệnh java:
# * DEFAULT_JVM_OPTS, JAVA_OPTS và optsEnvironmentVar không được phép chứa các đoạn mã lệnh shell.
# và mọi mã shellness nhúng bên trong sẽ được mã hóa.
# * Ví dụ: Người dùng không thể mong đợi biến môi trường ${Hostname} được mở rộng, vì nó là một biến môi trường và sẽ được
# được coi là chính '${Hostname}' trên dòng lệnh.

bộ -- \
        "-Dorg.gradle.appname=$APP_BASE_NAME" \
        -jar "$APP_HOME/gradle/wrapper/gradle-wrapper.jar" \
        "$@"

# Dừng lại khi "xargs" không khả dụng.
if ! command -v xargs >/dev/null 2>&1
sau đó
    lỗi "xargs không khả dụng"
fi

# Sử dụng "xargs" để phân tích các đối số được trích dẫn.
#
# Với tùy chọn -n1, nó sẽ xuất ra mỗi đối số trên một dòng, loại bỏ dấu ngoặc kép và dấu gạch chéo ngược.
#
# Trong Bash, chúng ta có thể đơn giản thực hiện như sau:
#
# readarray ARGS < <( xargs -n1 <<<"$var" ) &&
# đặt -- "${ARGS[@]}" "$@"
#
# nhưng shell POSIX không có mảng cũng như không có lệnh thay thế, vì vậy thay vào đó chúng ta
# Xử lý hậu kỳ từng đối số (như một dòng đầu vào cho sed) để thoát bằng dấu gạch chéo ngược bất kỳ
# ký tự có thể là ký tự đặc biệt của shell, sau đó sử dụng eval để đảo ngược
# quá trình đó (trong khi vẫn duy trì sự tách biệt giữa các đối số) và bao bọc
# Gom toàn bộ lại thành một câu lệnh "set" duy nhất.
#
# Điều này tất nhiên sẽ bị lỗi nếu bất kỳ biến nào trong số này chứa ký tự xuống dòng hoặc
# Một câu nói xuất sắc.
#

đánh giá "đặt -- $(
        printf '%s\n' "$DEFAULT_JVM_OPTS $JAVA_OPTS $GRADLE_OPTS" |
        xargs -n1 |
        sed ' s~[^-[:alnum:]+,./:=@_]~\\&~g; ' |
        tr '\n' ' '
    )" '"$@"'

exec "$JAVACMD" "$@"
